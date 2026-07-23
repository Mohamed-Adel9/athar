import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remoteDataSource);

  final CartRemoteDataSource _remoteDataSource;

  @override
  Future<Result<CartModel>> fetchCart() async {
    try {
      final cart = await _remoteDataSource.fetchCart();
      return Success(cart);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<CartModel>> addItem(CartItemModel item) async {
    try {
      final cart = await _remoteDataSource.addItem(item);
      return Success(cart);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<CartModel>> updateQuantity(String id, int quantity) async {
    try {
      final cart = await _remoteDataSource.updateQuantity(id, quantity);
      return Success(cart);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<CartModel>> removeItem(String id) async {
    try {
      final cart = await _remoteDataSource.removeItem(id);
      return Success(cart);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _remoteDataSource.clearCart();
      return const Success(null);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<void>> placeOrder(Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.placeOrder(data);
      return const Success(null);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
