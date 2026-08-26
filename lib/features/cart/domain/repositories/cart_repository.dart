import '../../../../core/utils/result.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/promo_code_model.dart';

abstract class CartRepository {
  Future<Result<CartModel>> fetchCart();

  Future<Result<CartModel>> addItem(CartItemModel item);

  Future<Result<CartModel>> updateQuantity(String id, int quantity);

  Future<Result<CartModel>> removeItem(String id);

  Future<Result<PromoCodeModel>> applyPromoCode({
    required String code,
    required double subtotal,
  });

  Future<Result<void>> clearCart();

  Future<Result<void>> placeOrder(Map<String, dynamic> data);
}
