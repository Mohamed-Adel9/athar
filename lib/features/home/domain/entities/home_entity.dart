class HomeDataEntity {
  const HomeDataEntity({
    required this.sliders,
    required this.banners,
    required this.categories,
    required this.products,
    required this.features,
    required this.reviews,
  });

  final List<HomeSliderEntity> sliders;
  final List<HomeBannerEntity> banners;
  final List<HomeCategoryEntity> categories;
  final List<HomeProductEntity> products;
  final List<HomeProductEntity> features;
  final List<HomeReviewEntity> reviews;

  HomeDataEntity copyWith({
    List<HomeSliderEntity>? sliders,
    List<HomeBannerEntity>? banners,
    List<HomeCategoryEntity>? categories,
    List<HomeProductEntity>? products,
    List<HomeProductEntity>? features,
    List<HomeReviewEntity>? reviews,
  }) {
    return HomeDataEntity(
      sliders: sliders ?? this.sliders,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      features: features ?? this.features,
      reviews: reviews ?? this.reviews,
    );
  }

  factory HomeDataEntity.empty() {
    return const HomeDataEntity(
      sliders: [],
      banners: [],
      categories: [],
      products: [],
      features: [],
      reviews: [],
    );
  }
}

class HomeSliderEntity {
  const HomeSliderEntity({
    required this.id,
    required this.url,
    required this.imageUrl,
    required this.displayTitle,
    required this.displayText,
  });

  final int id;
  final String? url;
  final String? imageUrl;
  final String displayTitle;
  final String displayText;
}

class HomeBannerEntity {
  const HomeBannerEntity({
    required this.id,
    required this.url,
    required this.imageUrl,
  });

  final int id;
  final String? url;
  final String? imageUrl;
}

class HomeCategoryEntity {
  const HomeCategoryEntity({
    required this.id,
    required this.displayTitle,
    required this.categoryTypeId,
    required this.imageUrl,
    required this.productsCount,
  });

  final int id;
  final String displayTitle;
  final int? categoryTypeId;
  final String? imageUrl;
  final int productsCount;
}

class HomeProductEntity {
  const HomeProductEntity({
    required this.id,
    required this.displayName,
    required this.imageUrl,
    required this.isFeatured,
    required this.categoryId,
    required this.category,
    required this.size,
    required this.price,
    required this.oldPrice,
    required this.quantity,
  });

  final int id;
  final String displayName;
  final String? imageUrl;
  final bool isFeatured;
  final int categoryId;
  final HomeCategoryEntity? category;
  final String size;
  final double price;
  final double oldPrice;
  final int quantity;

  bool get hasDiscount => oldPrice > price && price > 0;

  int get discountPercent {
    if (!hasDiscount || oldPrice == 0) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
  }
}

class HomeReviewEntity {
  const HomeReviewEntity({
    required this.id,
    required this.displayName,
    required this.displayText,
    this.rating = 5,
  });

  final int id;
  final String displayName;
  final String displayText;
  final int rating;
}
