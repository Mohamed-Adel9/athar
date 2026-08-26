class WishlistItemModel {
  final int id;
  final int? productId;
  final String title;
  final double price;
  final String image;
  final bool inStock;

  const WishlistItemModel({
    required this.id,
    this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.inStock,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final product = _map(json['product']);
    final productId = _int(
      json['product_id'] ?? json['productId'] ?? product['id'],
    );
    final id = productId ?? _int(json['id']) ?? json.hashCode;

    return WishlistItemModel(
      id: id,
      productId: productId,
      title: _string(
        json['name'] ??
            json['title'] ??
            product['name'] ??
            product['title'] ??
            product['display_name'],
      ),
      price: _double(json['price'] ?? product['price']),
      image: _string(
        json['image'] ??
            json['image_url'] ??
            json['imageUrl'] ??
            product['image'] ??
            product['image_url'] ??
            product['imageUrl'] ??
            product['main_image'] ??
            product['thumbnail'],
      ),
      inStock: _bool(
        json['in_stock'] ??
            json['inStock'] ??
            json['is_available'] ??
            product['in_stock'] ??
            product['inStock'] ??
            product['is_available'] ??
            true,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (productId != null) 'product_id': productId,
      'title': title,
      'price': price,
      'image': image,
      'in_stock': inStock,
    };
  }

  WishlistItemModel copyWith({
    int? id,
    int? productId,
    String? title,
    double? price,
    String? image,
    bool? inStock,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      inStock: inStock ?? this.inStock,
    );
  }
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

String _string(Object? value) {
  if (value == null) return '';
  if (value is Map<String, dynamic>) {
    final ar = value['ar']?.toString().trim();
    if (ar != null && ar.isNotEmpty) return ar;

    final en = value['en']?.toString().trim();
    if (en != null && en.isNotEmpty) return en;
  }
  return value.toString();
}

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _bool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == null ||
      normalized.isEmpty ||
      normalized == 'true' ||
      normalized == '1' ||
      normalized == 'yes';
}
