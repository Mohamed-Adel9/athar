import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> fetchWishlist();

  Future<void> saveWishlist(List<WishlistItemModel> items);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  const WishlistLocalDataSourceImpl(this._storage);

  static const _wishlistKey = 'wishlist_items';

  final FlutterSecureStorage _storage;

  @override
  Future<List<WishlistItemModel>> fetchWishlist() async {
    final value = await _storage.read(key: _wishlistKey);
    if (value == null || value.trim().isEmpty) return const [];

    final decoded = jsonDecode(value);
    if (decoded is! List) return const [];

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(WishlistItemModel.fromJson)
        .toList();
  }

  @override
  Future<void> saveWishlist(List<WishlistItemModel> items) async {
    await _storage.write(
      key: _wishlistKey,
      value: jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
