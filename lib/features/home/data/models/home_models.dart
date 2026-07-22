import '../../../../core/const_data/api_urls.dart';
import '../../domain/entities/home_entity.dart';

class HomeResponseModel {
  const HomeResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final HomeDataModel data;

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: HomeDataModel.fromJson(_map(json['data'])),
    );
  }
}

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required super.sliders,
    required super.banners,
    required super.categories,
    required super.products,
    required super.features,
    required super.reviews,
  });

  factory HomeDataModel.empty() {
    return const HomeDataModel(
      sliders: [],
      banners: [],
      categories: [],
      products: [],
      features: [],
      reviews: [],
    );
  }

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      sliders: _list(json['sliders']).map(HomeSliderModel.fromJson).toList(),
      banners: _list(json['banners']).map(HomeBannerModel.fromJson).toList(),
      categories: _list(
        json['categories'],
      ).map(HomeCategoryModel.fromJson).toList(),
      products: _list(json['products']).map(HomeProductModel.fromJson).toList(),
      features: _list(json['features']).map(HomeProductModel.fromJson).toList(),
      reviews: _list(json['reviews']).map(HomeReviewModel.fromJson).toList(),
    );
  }
}

class HomeSliderModel extends HomeSliderEntity {
  const HomeSliderModel({
    required super.id,
    required super.url,
    required super.imageUrl,
    required super.displayTitle,
    required super.displayText,
  });

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) {
    return HomeSliderModel(
      id: _int(json['id']),
      url: json['url']?.toString(),
      imageUrl: _mediaUrl(json['image']?.toString()),
      displayTitle: LocalizedText.fromJson(json['title']).display,
      displayText: LocalizedText.fromJson(json['text']).display,
    );
  }
}

class HomeBannerModel extends HomeBannerEntity {
  const HomeBannerModel({
    required super.id,
    required super.url,
    required super.imageUrl,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: _int(json['id']),
      url: json['url']?.toString(),
      imageUrl: _mediaUrl(json['image']?.toString()),
    );
  }
}

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({
    required super.id,
    required super.displayTitle,
    required super.categoryTypeId,
    required super.imageUrl,
    required super.productsCount,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: _int(json['id']),
      displayTitle: LocalizedText.fromJson(json['title']).display,
      categoryTypeId: _nullableInt(json['category_type_id']),
      imageUrl: _mediaUrl(json['image']?.toString()),
      productsCount: _int(json['products_count']),
    );
  }
}

class HomeProductModel extends HomeProductEntity {
  const HomeProductModel({
    required super.id,
    required super.displayName,
    required super.imageUrl,
    required super.isFeatured,
    required super.categoryId,
    required super.category,
    required super.size,
    required super.price,
    required super.oldPrice,
    required super.quantity,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    final variant = json['one_variant'] is Map<String, dynamic>
        ? HomeProductVariantModel.fromJson(_map(json['one_variant']))
        : null;
    final productImage = json['one_image'] is Map<String, dynamic>
        ? HomeProductImageModel.fromJson(_map(json['one_image']))
        : null;

    return HomeProductModel(
      id: _int(json['id']),
      displayName: LocalizedText.fromJson(json['name']).display,
      imageUrl: _mediaUrl(json['image']?.toString()) ?? productImage?.imageUrl,
      isFeatured: _bool(json['is_featured']),
      categoryId: _int(json['category_id']),
      category: json['category'] is Map<String, dynamic>
          ? HomeCategoryModel.fromJson(_map(json['category']))
          : null,
      size: variant?.size ?? '',
      price: variant?.price ?? 0,
      oldPrice: variant?.oldPrice ?? 0,
      quantity: variant?.quantity ?? 0,
    );
  }
}

class HomeProductVariantModel {
  const HomeProductVariantModel({
    required this.id,
    required this.size,
    required this.quantity,
    required this.price,
    required this.oldPrice,
  });

  final int id;
  final String size;
  final int quantity;
  final double price;
  final double oldPrice;

  factory HomeProductVariantModel.fromJson(Map<String, dynamic> json) {
    return HomeProductVariantModel(
      id: _int(json['id']),
      size: json['size']?.toString() ?? '',
      quantity: _int(json['quantity']),
      price: _double(json['price']),
      oldPrice: _double(json['old_price']),
    );
  }
}

class HomeProductImageModel {
  const HomeProductImageModel({required this.id, required this.image});

  final int id;
  final String? image;

  String? get imageUrl => _mediaUrl(image);

  factory HomeProductImageModel.fromJson(Map<String, dynamic> json) {
    return HomeProductImageModel(
      id: _int(json['id']),
      image: json['image']?.toString(),
    );
  }
}

class HomeReviewModel extends HomeReviewEntity {
  const HomeReviewModel({
    required super.id,
    required super.displayName,
    required super.displayText,
    super.rating,
  });

  factory HomeReviewModel.fromJson(Map<String, dynamic> json) {
    return HomeReviewModel(
      id: _int(json['id']),
      displayName: LocalizedText.fromJson(json['name']).display,
      displayText: LocalizedText.fromJson(json['text']).display,
      rating: _int(json['rating']) == 0 ? 5 : _int(json['rating']),
    );
  }
}

class LocalizedText {
  const LocalizedText({this.ar, this.en});

  final String? ar;
  final String? en;

  String get display {
    final arabic = ar?.trim();
    if (arabic != null && arabic.isNotEmpty) return arabic;

    final english = en?.trim();
    if (english != null && english.isNotEmpty) return english;

    return '';
  }

  factory LocalizedText.fromJson(Object? value) {
    if (value is Map<String, dynamic>) {
      return LocalizedText(
        ar: value['ar']?.toString(),
        en: value['en']?.toString(),
      );
    }

    return LocalizedText(ar: value?.toString());
  }
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return [];
  return value.whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _nullableInt(Object? value) {
  if (value == null) return null;
  return _int(value);
}

double _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _bool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes';
}

String? _mediaUrl(String? path) {
  if (path == null || path.trim().isEmpty) return null;
  final value = path.trim();
  if (value.contains(r':\') || value.contains(r'%5C')) return null;
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }

  final baseUri = Uri.tryParse(ApiUrls.baseUrl);
  if (baseUri == null || !baseUri.hasScheme || baseUri.host.isEmpty) {
    return null;
  }

  final origin = '${baseUri.scheme}://${baseUri.authority}';
  return value.startsWith('/') ? '$origin$value' : '$origin/$value';
}
