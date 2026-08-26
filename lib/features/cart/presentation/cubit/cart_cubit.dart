import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/payment_method.dart';
import '../../data/models/shipping_info_model.dart';
import '../../domain/usecases/add_cart_item_usecase.dart';
import '../../domain/usecases/apply_promo_code_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/fetch_cart_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';
import '../../domain/usecases/remove_cart_item_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(
    this._fetchCartUseCase,
    this._addCartItemUseCase,
    this._updateCartItemUseCase,
    this._removeCartItemUseCase,
    this._applyPromoCodeUseCase,
    this._clearCartUseCase,
    this._placeOrderUseCase,
  ) : super(const CartState());

  final FetchCartUseCase _fetchCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ApplyPromoCodeUseCase _applyPromoCodeUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  int _revision = 0;

  //  Navigation

  void goToCart() => emit(state.copyWith(currentStep: 0, clearError: true));
  void goToShipping() {
    if (state.canProceedToShipping) {
      emit(state.copyWith(currentStep: 1, clearError: true));
    }
  }

  void goToPayment() {
    if (state.canProceedToPayment) {
      emit(state.copyWith(currentStep: 2, clearError: true));
    }
  }

  void goBack() {
    if (state.currentStep > 0) {
      emit(
        state.copyWith(currentStep: state.currentStep - 1, clearError: true),
      );
    }
  }

  //  Cart Items

  Future<void> fetchCart() async {
    final revision = _revision;
    emit(state.copyWith(status: CartStatus.loading, clearError: true));
    final result = await _fetchCartUseCase();
    result.fold(
      (failure) {
        if (!_isCurrentRevision(revision)) return;
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (cart) {
        if (!_isCurrentRevision(revision)) return;
        _emitCart(cart, status: CartStatus.initial);
      },
    );
  }

  void addItem(CartItemModel item) {
    final previous = state;
    final revision = _revision;
    final matchingItems = state.items
        .where((cartItem) => _sameCartLine(cartItem, item))
        .toList();

    if (matchingItems.isNotEmpty) {
      final existingItem = matchingItems.first;
      final newQuantity =
          matchingItems.fold<int>(item.quantity, (sum, i) => sum + i.quantity);
      final updated = _mergeCartItems(
        state.items
            .where((cartItem) => !_sameCartLine(cartItem, item))
            .toList()
          ..add(existingItem.copyWith(quantity: newQuantity)),
      );
      emit(state.copyWith(items: updated));
      unawaited(
        _updateQuantityInBackend(
          existingItem.id,
          newQuantity,
          previous,
          revision,
        ),
      );
    } else {
      final updated = _mergeCartItems([...state.items, item]);
      emit(state.copyWith(items: updated));
      unawaited(_addItemToBackend(item, previous, revision));
    }
  }

  void removeItem(String id) {
    final previous = state;
    final revision = _revision;
    emit(state.copyWith(items: state.items.where((i) => i.id != id).toList()));
    unawaited(_removeItemFromBackend(id, previous, revision));
  }

  void updateQuantity(String id, int quantity) {
    if (quantity < 1) {
      removeItem(id);
      return;
    }

    final updated = state.items.map((item) {
      if (item.id == id) return item.copyWith(quantity: quantity);
      return item;
    }).toList();

    final previous = state;
    final revision = _revision;
    emit(state.copyWith(items: updated));
    unawaited(_updateQuantityInBackend(id, quantity, previous, revision));
  }

  void incrementQuantity(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    updateQuantity(id, item.quantity + 1);
  }

  void decrementQuantity(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    updateQuantity(id, item.quantity - 1);
  }

  //  Promo Code

  Future<bool> applyPromoCode(String code) async {
    final promoCode = code.trim();

    final result = await _applyPromoCodeUseCase(
      code: promoCode,
      subtotal: state.subtotal,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            promoCode: promoCode,
            discount: 0,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (promo) {
        emit(
          state.copyWith(
            promoCode: promo.code.isEmpty ? promoCode : promo.code,
            discount: promo.discountFor(state.subtotal),
            clearError: true,
          ),
        );
        return true;
      },
    );
  }

  //  Shipping

  void updateShippingInfo(ShippingInfoModel info) {
    emit(state.copyWith(shippingInfo: info, clearError: true));
  }

  //  Payment

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(paymentMethod: method));
  }

  //  Order

  Future<void> placeOrder() async {
    if (!state.canPlaceOrder) return;

    final placedPaymentMethod = state.paymentMethod;
    final placedTotal = state.total;
    emit(state.copyWith(status: CartStatus.loading, clearError: true));

    final result = await _placeOrderUseCase(_orderPayload());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        if (placedPaymentMethod == PaymentMethod.instapay) {
          unawaited(_savePendingInstapayOrder(placedTotal));
        }
        emit(
          state.copyWith(
            status: CartStatus.success,
            currentStep: 3,
            items: [],
            promoCode: '',
            discount: 0,
          ),
        );
      },
    );
  }

  void reset() {
    _revision++;
    emit(const CartState());
    unawaited(_clearCart());
  }

  void clearLocal() {
    _revision++;
    emit(const CartState());
  }

  Future<void> _addItemToBackend(
    CartItemModel item,
    CartState previous,
    int revision,
  ) async {
    final result = await _addCartItemUseCase(item);
    result.fold(
      (failure) {
        if (!_isCurrentRevision(revision)) return;
        emit(
          previous.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (cart) {
        if (!_isCurrentRevision(revision)) return;
        _emitCart(cart);
      },
    );
  }

  Future<void> _updateQuantityInBackend(
    String id,
    int quantity,
    CartState previous,
    int revision,
  ) async {
    final result = await _updateCartItemUseCase(id, quantity);
    result.fold(
      (failure) {
        if (!_isCurrentRevision(revision)) return;
        emit(
          previous.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (cart) {
        if (!_isCurrentRevision(revision)) return;
        _emitCart(cart);
      },
    );
  }

  Future<void> _removeItemFromBackend(
    String id,
    CartState previous,
    int revision,
  ) async {
    final result = await _removeCartItemUseCase(id);
    result.fold(
      (failure) {
        if (!_isCurrentRevision(revision)) return;
        emit(
          previous.copyWith(
            status: CartStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (cart) {
        if (!_isCurrentRevision(revision)) return;
        _emitCart(cart);
      },
    );
  }

  Future<void> _clearCart() async {
    await _clearCartUseCase();
  }

  void _emitCart(CartModel cart, {CartStatus status = CartStatus.initial}) {
    final items = _mergeCartItems(cart.items);
    if (items.length != cart.items.length) {
      unawaited(_syncMergedCartItems(cart.items));
    }

    emit(
      state.copyWith(
        items: items,
        deliveryFee: cart.deliveryFee,
        discount: cart.discount,
        status: status,
        clearError: true,
      ),
    );
  }

  Future<void> _syncMergedCartItems(List<CartItemModel> items) async {
    final groups = <List<CartItemModel>>[];

    for (final item in items) {
      final index = groups.indexWhere(
        (group) => _sameCartLine(group.first, item),
      );
      if (index == -1) {
        groups.add([item]);
      } else {
        groups[index].add(item);
      }
    }

    for (final group in groups.where((group) => group.length > 1)) {
      final primary = group.first;
      final quantity = group.fold<int>(0, (sum, item) => sum + item.quantity);

      if (primary.quantity != quantity) {
        await _updateCartItemUseCase(primary.id, quantity);
      }

      for (final duplicate in group.skip(1)) {
        await _removeCartItemUseCase(duplicate.id);
      }
    }
  }

  List<CartItemModel> _mergeCartItems(List<CartItemModel> items) {
    final merged = <CartItemModel>[];

    for (final item in items) {
      final index = merged.indexWhere((current) => _sameCartLine(current, item));
      if (index == -1) {
        merged.add(item);
        continue;
      }

      final current = merged[index];
      merged[index] = current.copyWith(
        quantity: current.quantity + item.quantity,
      );
    }

    return merged;
  }

  bool _sameCartLine(CartItemModel current, CartItemModel incoming) {
    if (current.productId != null && incoming.productId != null) {
      return current.productId == incoming.productId &&
          _sameOption(current.color, incoming.color) &&
          _sameOption(current.size, incoming.size);
    }

    return current.id == incoming.id ||
        (current.name == incoming.name &&
            current.price == incoming.price &&
            _sameOption(current.imageUrl, incoming.imageUrl) &&
            _sameOption(current.color, incoming.color) &&
            _sameOption(current.size, incoming.size));
  }

  bool _sameOption(String left, String right) {
    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }

  bool _isCurrentRevision(int revision) => revision == _revision;

  Future<void> _savePendingInstapayOrder(double total) async {
    try {
      final file = await _pendingInstapayOrdersFile();
      final orders = await _readPendingInstapayOrders(file);
      orders.add({
        'total': total,
        'created_at': DateTime.now().toIso8601String(),
      });
      await file.writeAsString(jsonEncode(orders));
    } catch (_) {
      return;
    }
  }

  Future<List<Map<String, dynamic>>> _readPendingInstapayOrders(
    File file,
  ) async {
    if (!await file.exists()) return [];
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! List) return [];
    return decoded.whereType<Map<String, dynamic>>().toList();
  }

  Future<File> _pendingInstapayOrdersFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/pending_instapay_orders.json');
  }

  Map<String, dynamic> _orderPayload() {
    return {
      'shipping_info': state.shippingInfo.toJson(),
      'payment_method': state.paymentMethod.name,
      if (state.paymentMethod == PaymentMethod.instapay) ...{
        'payment_provider': 'instapay',
        'payment_status': 'awaiting_transfer_proof',
      },
      if (state.promoCode.isNotEmpty) 'promo_code': state.promoCode,
      'items': state.items.map((item) => item.toCartPayload()).toList(),
      'subtotal': state.subtotal,
      'delivery_fee': state.deliveryFee,
      'discount': state.discount,
      'total': state.total,
    };
  }
}
