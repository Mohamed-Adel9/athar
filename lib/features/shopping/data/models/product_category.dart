enum ProductCategory {
  all,
  tshirts,
  hoodies,
  mugs,
  accessories,
  stickers,
  hats,
}

enum ProductFilterType { all, categoryType, category }

class ProductFilter {
  const ProductFilter({
    required this.id,
    required this.title,
    required this.type,
    this.productsCount = 0,
  });

  final int id;
  final String title;
  final ProductFilterType type;
  final int productsCount;

  String get key => '${type.name}-$id';

  factory ProductFilter.all() {
    return const ProductFilter(
      id: 0,
      title: 'الكل',
      type: ProductFilterType.all,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilter &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => Object.hash(id, type);
}

extension ProductCategoryX on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.all:
        return 'الكل';
      case ProductCategory.tshirts:
        return 'تيشيرتات';
      case ProductCategory.hoodies:
        return 'هودي';
      case ProductCategory.mugs:
        return 'أكواب';
      case ProductCategory.accessories:
        return 'إطارات';
      case ProductCategory.stickers:
        return 'حلقات';
      case ProductCategory.hats:
        return 'هدايا';
    }
  }
}
