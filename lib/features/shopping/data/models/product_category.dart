enum ProductCategory {
  all,
  tshirts,
  hoodies,
  mugs,
  accessories,
  stickers,
  hats,
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
