import '../../../../core/utils/result.dart';
import '../../data/models/wishlist_item_model.dart';
import '../repositories/wishlist_repository.dart';

class FetchWishlistUseCase {
  const FetchWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  Future<Result<List<WishlistItemModel>>> call() {
    return _repository.fetchWishlist();
  }
}
