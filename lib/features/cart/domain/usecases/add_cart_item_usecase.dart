import '../../../../core/utils/result.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';

class AddCartItemUseCase {
  const AddCartItemUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<CartModel>> call(CartItemModel item) {
    return _repository.addItem(item);
  }
}
