import '../../data/models/wishlist_item_model.dart';
import '../repositories/wishlist_repository.dart';

class SaveCachedWishlistUseCase {
  const SaveCachedWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<void> call(List<WishlistItemModel> items) {
    return _repository.saveCachedWishlist(items);
  }
}
