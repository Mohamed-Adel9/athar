import '../../../../core/utils/result.dart';
import '../../data/models/wishlist_item_model.dart';

abstract class WishlistRepository {
  Future<List<WishlistItemModel>> fetchCachedWishlist();

  Future<void> saveCachedWishlist(List<WishlistItemModel> items);

  Future<Result<List<WishlistItemModel>>> fetchWishlist();

  Future<Result<void>> addItem(WishlistItemModel item);

  Future<Result<void>> removeItem(WishlistItemModel item);
}
