import '../../../../core/utils/result.dart';
import '../../data/models/wishlist_item_model.dart';
import '../repositories/wishlist_repository.dart';

class AddWishlistItemUseCase {
  const AddWishlistItemUseCase(this._repository);

  final WishlistRepository _repository;

  Future<Result<void>> call(WishlistItemModel item) {
    return _repository.addItem(item);
  }
}
