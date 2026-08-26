import '../../data/models/wishlist_item_model.dart';
import '../repositories/wishlist_repository.dart';

class FetchCachedWishlistUseCase {
  const FetchCachedWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<List<WishlistItemModel>> call() {
    return _repository.fetchCachedWishlist();
  }
}
