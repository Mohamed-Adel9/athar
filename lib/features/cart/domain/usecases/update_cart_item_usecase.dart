import '../../../../core/utils/result.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  const UpdateCartItemUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<CartModel>> call(String id, int quantity) {
    return _repository.updateQuantity(id, quantity);
  }
}
