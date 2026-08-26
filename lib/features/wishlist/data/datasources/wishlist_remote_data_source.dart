import '../../../../core/const_data/api_urls.dart';
import '../../../../core/network/dio_service.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> fetchWishlist();

  Future<void> addItem(WishlistItemModel item);

  Future<void> removeItem(WishlistItemModel item);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  const WishlistRemoteDataSourceImpl(this._dioService);

  final DioService _dioService;

  @override
  Future<List<WishlistItemModel>> fetchWishlist() async {
    final response = await _dioService.get(url: ApiUrls.wishlist);

    return _wishlistItems(response.data);
  }

  @override
  Future<void> addItem(WishlistItemModel item) async {
    final productId = _productId(item);
    await _dioService.post(
      url: ApiUrls.wishlist,
      data: {'product_id': productId},
    );
  }

  @override
  Future<void> removeItem(WishlistItemModel item) async {
    await _dioService.delete(url: ApiUrls.wishlistProduct(_productId(item)));
  }

  int _productId(WishlistItemModel item) {
    final productId = item.productId ?? item.id;
    if (productId < 1) {
      throw const FormatException('Product id is required for wishlist sync.');
    }
    return productId;
  }
}

List<WishlistItemModel> _wishlistItems(Object? value) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().map(_wishlistItem).toList();
  }

  if (value is! Map<String, dynamic>) return const [];

  for (final key in const ['data', 'items', 'wishlist', 'favorites']) {
    if (!value.containsKey(key)) continue;

    final items = _wishlistItems(value[key]);
    return items;
  }

  return [_wishlistItem(value)];
}

WishlistItemModel _wishlistItem(Map<String, dynamic> json) {
  final product = json['product'];
  if (product is Map<String, dynamic>) {
    return WishlistItemModel.fromJson({
      ...product,
      'id': json['id'] ?? product['id'],
      'product_id': json['product_id'] ?? product['id'],
    });
  }

  return WishlistItemModel.fromJson(json);
}
