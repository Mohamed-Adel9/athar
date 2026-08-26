import '../../../../core/failure/api_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_data_source.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../models/wishlist_item_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  const WishlistRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final WishlistRemoteDataSource _remoteDataSource;
  final WishlistLocalDataSource _localDataSource;

  @override
  Future<List<WishlistItemModel>> fetchCachedWishlist() {
    return _localDataSource.fetchWishlist();
  }

  @override
  Future<void> saveCachedWishlist(List<WishlistItemModel> items) {
    return _localDataSource.saveWishlist(items);
  }

  @override
  Future<Result<List<WishlistItemModel>>> fetchWishlist() async {
    try {
      final items = await _remoteDataSource.fetchWishlist();
      await _localDataSource.saveWishlist(items);
      return Success(items);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<void>> addItem(WishlistItemModel item) async {
    try {
      await _remoteDataSource.addItem(item);
      return const Success(null);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }

  @override
  Future<Result<void>> removeItem(WishlistItemModel item) async {
    try {
      await _remoteDataSource.removeItem(item);
      return const Success(null);
    } catch (error) {
      return FailureResult(ApiFailure.fromException(error));
    }
  }
}
