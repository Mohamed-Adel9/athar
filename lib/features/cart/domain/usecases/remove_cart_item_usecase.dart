import '../../../../core/utils/result.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  const RemoveCartItemUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<CartModel>> call(String id) {
    return _repository.removeItem(id);
  }
}
