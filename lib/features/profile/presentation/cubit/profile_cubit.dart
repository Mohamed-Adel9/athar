import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../data/models/profile_order_model.dart';
import '../../domain/usecases/fetch_profile_usecase.dart';
import '../../domain/usecases/upload_payment_proof_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._fetchProfileUseCase,
    this._updateProfileUseCase,
    this._uploadPaymentProofUseCase,
  )
    : super(ProfileState.initial()) {
    unawaited(_loadPaymentProofs());
  }

  final FetchProfileUseCase _fetchProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadPaymentProofUseCase _uploadPaymentProofUseCase;

  Future<void> fetchProfile({int? wishlistCount}) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        wishlist: wishlistCount,
        clearError: true,
      ),
    );

    final result = await _fetchProfileUseCase();
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) async {
        final orderItems = await _ordersWithLocalInstapayPayments(
          profile.orders,
        );
        emit(
          state.copyWith(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            orders: orderItems.length,
            designs: profile.designs.length,
            orderItems: orderItems,
            savedDesigns: profile.designs,
            wishlist: wishlistCount,
            status: ProfileStatus.success,
            clearError: true,
          ),
        );
      },
    );
  }

  void selectSection(ProfileSection section) {
    emit(state.copyWith(selectedSection: section));
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    emit(state.copyWith(isUpdating: true, clearError: true));
    final result = await _updateProfileUseCase(name: name, email: email);

    return result.fold<Future<bool>>(
      (failure) async {
        emit(
          state.copyWith(
            isUpdating: false,
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (profile) async {
        final orderItems = await _ordersWithLocalInstapayPayments(
          profile.orders,
        );
        emit(
          state.copyWith(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            orders: orderItems.length,
            designs: profile.designs.length,
            orderItems: orderItems,
            savedDesigns: profile.designs,
            isUpdating: false,
            status: ProfileStatus.success,
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  void updateWishlistCount(int count) {
    emit(state.copyWith(wishlist: count));
  }

  Future<bool> addPaymentProof(int orderId) async {
    final image = await ImagePickerService.pick();
    if (image == null) return false;

    final directory = await getApplicationDocumentsDirectory();
    final extension = _fileExtension(image.path);
    final savedImage = await image.copy(
      '${directory.path}/instapay_proof_order_$orderId.$extension',
    );

    final result = await _uploadPaymentProofUseCase(
      orderId: orderId,
      proof: savedImage,
    );

    return result.fold<Future<bool>>(
      (failure) async {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (updatedOrder) async {
        final proofSource = updatedOrder.paymentProofUrl?.isNotEmpty == true
            ? updatedOrder.paymentProofUrl!
            : savedImage.path;
        final paymentProofs = {
          ...state.paymentProofs,
          orderId: proofSource,
        };
        final orderItems = state.orderItems.map((order) {
          if (order.id != orderId) return order;
          return updatedOrder.copyWith(
            paymentMethod: updatedOrder.paymentMethod.isEmpty
                ? 'instapay'
                : updatedOrder.paymentMethod,
            paymentProofUrl: proofSource,
          );
        }).toList();

        emit(
          state.copyWith(
            orderItems: orderItems,
            paymentProofs: paymentProofs,
            status: ProfileStatus.success,
            clearError: true,
          ),
        );
        await _savePaymentProofs(paymentProofs);
        await _saveInstapayOrderIds({
          ...await _loadInstapayOrderIds(),
          orderId,
        });
        return true;
      },
    );
  }

  Future<List<ProfileOrderModel>> _ordersWithLocalInstapayPayments(
    List<ProfileOrderModel> orders,
  ) async {
    final instapayOrderIds = await _loadInstapayOrderIds();
    final pendingOrders = await _loadPendingInstapayOrders();
    final remainingPendingOrders = <Map<String, dynamic>>[];
    var changed = false;

    for (final pendingOrder in pendingOrders) {
      final total = _double(pendingOrder['total']);
      final matchedOrder = _matchingInstapayOrder(
        orders: orders,
        usedIds: instapayOrderIds,
        total: total,
      );

      if (matchedOrder == null) {
        if (_isFreshPendingOrder(pendingOrder)) {
          remainingPendingOrders.add(pendingOrder);
        } else {
          changed = true;
        }
        continue;
      }

      instapayOrderIds.add(matchedOrder.id);
      changed = true;
    }

    if (changed) {
      await _saveInstapayOrderIds(instapayOrderIds);
      await _savePendingInstapayOrders(remainingPendingOrders);
    }

    return orders.map((order) {
      if (order.isInstapayPayment || instapayOrderIds.contains(order.id)) {
        return order.copyWith(paymentMethod: 'instapay');
      }
      return order;
    }).toList();
  }

  ProfileOrderModel? _matchingInstapayOrder({
    required List<ProfileOrderModel> orders,
    required Set<int> usedIds,
    required double total,
  }) {
    for (final order in orders) {
      if (usedIds.contains(order.id)) continue;
      if (order.paymentMethod.isNotEmpty && !order.isInstapayPayment) continue;
      if ((order.total - total).abs() > .01) continue;
      return order;
    }
    return null;
  }

  bool _isFreshPendingOrder(Map<String, dynamic> pendingOrder) {
    final createdAt = DateTime.tryParse(
      pendingOrder['created_at']?.toString() ?? '',
    );
    if (createdAt == null) return true;
    return DateTime.now().difference(createdAt).inDays < 14;
  }

  Future<void> _loadPaymentProofs() async {
    try {
      final file = await _paymentProofsFile();
      if (!await file.exists()) return;

      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;

      emit(
        state.copyWith(
          paymentProofs: decoded.map(
            (key, value) => MapEntry(int.tryParse(key) ?? 0, value.toString()),
          )..removeWhere((key, value) => key == 0 || value.isEmpty),
        ),
      );
    } catch (_) {
      return;
    }
  }

  Future<void> _savePaymentProofs(Map<int, String> paymentProofs) async {
    final file = await _paymentProofsFile();
    await file.writeAsString(
      jsonEncode(paymentProofs.map((key, value) => MapEntry('$key', value))),
    );
  }

  Future<File> _paymentProofsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/instapay_payment_proofs.json');
  }

  Future<Set<int>> _loadInstapayOrderIds() async {
    final file = await _instapayOrderIdsFile();
    if (!await file.exists()) return <int>{};

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! List) return <int>{};

    return decoded
        .map((value) => int.tryParse(value.toString()) ?? 0)
        .where((id) => id > 0)
        .toSet();
  }

  Future<void> _saveInstapayOrderIds(Set<int> orderIds) async {
    final file = await _instapayOrderIdsFile();
    await file.writeAsString(jsonEncode(orderIds.toList()..sort()));
  }

  Future<File> _instapayOrderIdsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/instapay_order_ids.json');
  }

  Future<List<Map<String, dynamic>>> _loadPendingInstapayOrders() async {
    final file = await _pendingInstapayOrdersFile();
    if (!await file.exists()) return [];

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! List) return [];
    return decoded.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> _savePendingInstapayOrders(
    List<Map<String, dynamic>> orders,
  ) async {
    final file = await _pendingInstapayOrdersFile();
    await file.writeAsString(jsonEncode(orders));
  }

  Future<File> _pendingInstapayOrdersFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/pending_instapay_orders.json');
  }
}

String _fileExtension(String path) {
  final extension = path.split('.').last.toLowerCase();
  if (extension == 'png' || extension == 'jpg' || extension == 'jpeg') {
    return extension;
  }
  return 'jpg';
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
