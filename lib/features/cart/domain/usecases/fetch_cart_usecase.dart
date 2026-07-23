import '../../../../core/utils/result.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';

class FetchCartUseCase {
  const FetchCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<CartModel>> call() {
    return _repository.fetchCart();
  }
}
