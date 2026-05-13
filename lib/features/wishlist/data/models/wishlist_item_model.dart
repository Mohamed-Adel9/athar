class WishlistItemModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final bool inStock;

  const WishlistItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.inStock,
  });

  WishlistItemModel copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    bool? inStock,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      inStock: inStock ?? this.inStock,
    );
  }
}
