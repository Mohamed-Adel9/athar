import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> fetchCart();

  Future<CartModel> addItem(CartItemModel item);

  Future<CartModel> updateQuantity(String id, int quantity);

  Future<CartModel> removeItem(String id);

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
