import 'package:dio/dio.dart';

import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/promo_code_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> fetchCart();

  Future<CartModel> addItem(CartItemModel item);

  Future<CartModel> updateQuantity(String id, int quantity);

  Future<CartModel> removeItem(String id);

  Future<PromoCodeModel> applyPromoCode({
    required String code,
    required double subtotal,
  });

  Future<void> clearCart();

  Future<void> placeOrder(Map<String, dynamic> data);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<CartModel> fetchCart() async {
    final response = await _dioService.get(url: ApiUrls.cart);
    return CartModel.fromJson(_map(response.data));
  }

  @override
  Future<CartModel> addItem(CartItemModel item) async {
    await _dioService.post(
      url: ApiUrls.cartItems,
      data: item.toCartPayload(),
    );
    return fetchCart();
  }

  @override
  Future<CartModel> updateQuantity(String id, int quantity) async {
    await _dioService.put(
      url: ApiUrls.cartItem(id),
      data: {'quantity': quantity},
    );
    return fetchCart();
  }

  @override
  Future<CartModel> removeItem(String id) async {
    await _dioService.delete(url: ApiUrls.cartItem(id));
    return fetchCart();
  }

  @override
  Future<PromoCodeModel> applyPromoCode({
    required String code,
    required double subtotal,
  }) async {
    for (final endpoint in ApiUrls.promoCodeEndpoints) {
      try {
        final response = await _dioService.post(
          url: endpoint,
          data: {
            'code': code,
            'subtotal': subtotal,
          },
        );
        return PromoCodeModel.fromJson(_map(response.data));
      } catch (error) {
        if (!_isMissingEndpoint(error)) rethrow;
      }
    }

    for (final endpoint in ApiUrls.promoCodeListEndpoints) {
      try {
        final response = await _dioService.get(url: '$endpoint/$code');
        return PromoCodeModel.fromJson(_map(response.data));
      } catch (error) {
        if (!_isMissingEndpoint(error)) rethrow;
      }
    }

    for (final endpoint in ApiUrls.promoCodeListEndpoints) {
      try {
        final response = await _dioService.get(url: endpoint);
        return _promoCodeFromList(response.data, code);
      } catch (error) {
        if (!_isMissingEndpoint(error)) rethrow;
      }
    }

    throw const FormatException(
      'لم يتم العثور على رابط أكواد الخصم في الـ API',
    );
  }

  @override
  Future<void> clearCart() async {
    await _dioService.delete(url: ApiUrls.cart);
  }

  @override
  Future<void> placeOrder(Map<String, dynamic> data) async {
    await _dioService.post(url: ApiUrls.orders, data: data);
  }
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

bool _isMissingEndpoint(Object error) {
  return error is DioException &&
      (error.response?.statusCode == 404 || error.response?.statusCode == 405);
}

PromoCodeModel _promoCodeFromList(Object? data, String code) {
  final promoCodes = _list(_map(data)['data']).isEmpty
      ? _list(data)
      : _list(_map(data)['data']);
  final normalizedCode = code.trim().toLowerCase();

  for (final promoCode in promoCodes) {
    final value = promoCode['code']?.toString().trim().toLowerCase();
    if (value == normalizedCode && _isActivePromoCode(promoCode)) {
      return PromoCodeModel.fromJson(promoCode);
    }
  }

  throw FormatException('Invalid promo code: $code');
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}

bool _isActivePromoCode(Map<String, dynamic> promoCode) {
  final active = promoCode['active'] ?? promoCode['is_active'] ?? true;
  if (active == false || active == 0 || active.toString() == '0') {
    return false;
  }

  final maxUse = _int(promoCode['max_use'] ?? promoCode['maxUse']);
  final usesCount = _int(promoCode['uses_count'] ?? promoCode['usesCount']);
  if (maxUse != null && usesCount != null && usesCount >= maxUse) {
    return false;
  }

  final now = DateTime.now();
  final startDate = _date(promoCode['start_date'] ?? promoCode['startDate']);
  final endDate = _date(promoCode['end_date'] ?? promoCode['endDate']);

  if (startDate != null && now.isBefore(startDate)) return false;
  if (endDate != null && now.isAfter(endDate)) return false;

  return true;
}

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

DateTime? _date(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;

  final isoDate = DateTime.tryParse(text);
  if (isoDate != null) return isoDate;

  final parts = text.split(RegExp(r'[-/]'));
  if (parts.length != 3) return null;

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) return null;
  return DateTime(year, month, day);
}
