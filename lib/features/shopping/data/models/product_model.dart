import 'package:athar/features/shopping/data/models/product_category.dart';
import 'package:athar/features/shopping/data/models/product_color.dart';
import 'package:athar/features/shopping/data/models/product_feature.dart';
import 'package:athar/features/shopping/data/models/product_review.dart';
import 'package:flutter/material.dart';

import '../../../../core/const_data/api_urls.dart';

class ProductResponseModel {
  const ProductResponseModel({required this.products, required this.filters});

  final List<ProductModel> products;
  final List<ProductFilter> filters;

  factory ProductResponseModel.fromJson(Object? json) {
    return ProductResponseModel(
      products: _productList(json).map(ProductModel.fromJson).toList(),
      filters: _filters(json),
    );
  }
}

class ProductCatalogModel {
  const ProductCatalogModel({required this.products, required this.filters});

  final List<ProductModel> products;
  final List<ProductFilter> filters;

  factory ProductCatalogModel.fromJson(Object? json) {
    final response = ProductResponseModel.fromJson(json);
    return ProductCatalogModel(
      products: response.products,
      filters: response.filters,
    );
  }
}

@immutable
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.colors,
    required this.sizes,
    required this.isNew,
    required this.discountPercent,
    required this.features,
    required this.reviews,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final ProductCategory category;
  final double rating;
  final int reviewCount;
  final List<ProductColor> colors;
  final List<String> sizes;
  final bool isNew;
  final int discountPercent;
  final List<ProductFeature> features;
  final List<ProductReview> reviews;

  double get discountAmount => originalPrice - price;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final variant = _firstMap([
      json['one_variant'],
      json['variant'],
      json['variants'],
      json['product_variants'],
    ]);
    final image = _firstMap([json['one_image'], json['image'], json['images']]);
    final categoryJson = _map(json['category']);
    final name = LocalizedText.fromJson(json['name']).display;
    final description = LocalizedText.fromJson(
      json['description'] ?? json['details'] ?? json['text'],
    ).display;
    final price = _double(json['price'] ?? variant['price']);
    final originalPrice = _double(
      json['original_price'] ?? json['old_price'] ?? variant['old_price'],
    );
    final categoryTitle = LocalizedText.fromJson(
      categoryJson['title'] ?? categoryJson['name'],
    ).display;
    final sizes = _sizes(json['sizes'], variant['size']);
    final colors = _colors(json['colors']);
    final reviews = _list(json['reviews']).map(ProductReviewModel.fromJson);

    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: name.isEmpty ? 'Product' : name,
      description: description,
      price: price,
      originalPrice: originalPrice > 0 ? originalPrice : price,
      imageUrl:
          _mediaUrl(json['image']?.toString()) ??
          _mediaUrl(json['main_image']?.toString()) ??
          _mediaUrl(json['thumbnail']?.toString()) ??
          _mediaUrl(image['image']?.toString()) ??
          _mediaUrl(image['url']?.toString()) ??
          '',
      category: _categoryFrom(
        id: _int(json['category_id'] ?? categoryJson['id']),
        title: categoryTitle,
      ),
      rating: _double(json['rating'] ?? json['rate']) == 0
          ? 5
          : _double(json['rating'] ?? json['rate']),
      reviewCount: _int(json['review_count'] ?? json['reviews_count']) ?? 0,
      colors: colors.isEmpty ? _defaultColors : colors,
      sizes: sizes.isEmpty ? const ['One Size'] : sizes,
      isNew: _bool(json['is_new'] ?? json['new']),
      discountPercent:
          _int(json['discount_percent']) ??
          _discountPercent(price, originalPrice),
      features: _defaultFeatures,
      reviews: reviews.toList(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    ProductCategory? category,
    double? rating,
    int? reviewCount,
    List<ProductColor>? colors,
    List<String>? sizes,
    bool? isNew,
    int? discountPercent,
    List<ProductFeature>? features,
    List<ProductReview>? reviews,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      isNew: isNew ?? this.isNew,
      discountPercent: discountPercent ?? this.discountPercent,
      features: features ?? this.features,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProductReviewModel extends ProductReview {
  const ProductReviewModel({
    required super.userName,
    required super.userImage,
    required super.date,
    required super.rating,
    required super.comment,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    final user = _map(json['user']);

    return ProductReviewModel(
      userName:
          json['user_name']?.toString() ??
          json['name']?.toString() ??
          user['name']?.toString() ??
          'User',
      userImage:
          _mediaUrl(json['user_image']?.toString()) ??
          'assets/images/onboarding1.png',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
      rating: _double(json['rating']) == 0 ? 5 : _double(json['rating']),
      comment: LocalizedText.fromJson(json['comment'] ?? json['text']).display,
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

const _defaultColors = [
  ProductColor(name: 'Default', color: Colors.white),
];

const _defaultFeatures = [
  ProductFeature(
    icon: Icons.local_shipping_outlined,
    title: 'Fast delivery',
    subtitle: '2-3 days',
  ),
  ProductFeature(
    icon: Icons.verified_outlined,
    title: 'Quality',
    subtitle: '100%',
  ),
  ProductFeature(
    icon: Icons.replay_outlined,
    title: 'Returns',
    subtitle: '14 days',
  ),
];

List<Map<String, dynamic>> _productList(Object? value) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().where(_looksLikeProduct).toList();
  }

  if (value is! Map<String, dynamic>) return [];

  for (final key in const ['products', 'items', 'results']) {
    final products = _productList(value[key]);
    if (products.isNotEmpty) return products;
  }

  final data = value['data'];
  if (data is List) {
    final products = _productList(data);
    if (products.isNotEmpty) return products;
  }

  if (data is Map<String, dynamic>) {
    for (final key in const ['products', 'items', 'results', 'data']) {
      final products = _productList(data[key]);
      if (products.isNotEmpty) return products;
    }
  }

  if (_looksLikeProduct(value)) return [value];

  return [];
}

List<ProductFilter> _filters(Object? value) {
  final data = value is Map<String, dynamic> ? _map(value['data']) : const {};
  final filters = <ProductFilter>[ProductFilter.all()];
  final seen = <String>{filters.first.key};

  void addFilter(ProductFilter filter) {
    if (seen.add(filter.key)) filters.add(filter);
  }

  for (final categoryType in _list(data['categoryTypes'])) {
    addFilter(
      ProductFilter(
        id: _int(categoryType['id']) ?? 0,
        title: LocalizedText.fromJson(categoryType['title']).display,
        type: ProductFilterType.categoryType,
        productsCount: _int(categoryType['products_count']) ?? 0,
      ),
    );
  }

  for (final category in _list(data['categories'])) {
    addFilter(
      ProductFilter(
        id: _int(category['id']) ?? 0,
        title: LocalizedText.fromJson(category['title']).display,
        type: ProductFilterType.category,
        productsCount: _int(category['products_count']) ?? 0,
      ),
    );
  }

  return filters.where((filter) => filter.title.trim().isNotEmpty).toList();
}

bool _looksLikeProduct(Map<String, dynamic> value) {
  return value.containsKey('name') ||
      value.containsKey('one_variant') ||
      value.containsKey('product_variants') ||
      value.containsKey('variants');
}

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return [];
  return value.whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> _map(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
}

Map<String, dynamic> _firstMap(List<Object?> values) {
  for (final value in values) {
    if (value is Map<String, dynamic>) return value;
    if (value is List) {
      for (final item in value) {
        if (item is Map<String, dynamic>) return item;
      }
    }
  }
  return const {};
}

int? _int(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
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

List<String> _sizes(Object? value, Object? fallback) {
  final values = <String>[];
  if (value is List) {
    for (final item in value) {
      if (item is Map<String, dynamic>) {
        final text = item['size'] ?? item['name'] ?? item['title'];
        if (text != null && text.toString().trim().isNotEmpty) {
          values.add(text.toString());
        }
      } else if (item != null && item.toString().trim().isNotEmpty) {
        values.add(item.toString());
      }
    }
  }
  if (values.isEmpty && fallback != null && fallback.toString().isNotEmpty) {
    values.add(fallback.toString());
  }
  return values;
}

List<ProductColor> _colors(Object? value) {
  if (value is! List) return const [];

  return value.map((item) {
    if (item is Map<String, dynamic>) {
      return ProductColor(
        name: item['name']?.toString() ?? item['title']?.toString() ?? 'Color',
        color: _parseColor(item['hex'] ?? item['color'] ?? item['value']),
      );
    }
    return ProductColor(name: item.toString(), color: _parseColor(item));
  }).toList();
}

Color _parseColor(Object? value) {
  final text = value?.toString().replaceAll('#', '').trim();
  if (text == null || text.isEmpty) return Colors.white;
  final hex = text.length == 6 ? 'FF$text' : text;
  return Color(int.tryParse(hex, radix: 16) ?? 0xFFFFFFFF);
}

ProductCategory _categoryFrom({int? id, required String title}) {
  final normalized = title.toLowerCase();
  if (normalized.contains('shirt') || normalized.contains('تيشيرت')) {
    return ProductCategory.tshirts;
  }
  if (normalized.contains('hood') || normalized.contains('هود')) {
    return ProductCategory.hoodies;
  }
  if (normalized.contains('mug') ||
      normalized.contains('cup') ||
      normalized.contains('كوب')) {
    return ProductCategory.mugs;
  }
  if (normalized.contains('sticker') || normalized.contains('ملصق')) {
    return ProductCategory.stickers;
  }
  if (normalized.contains('hat') || normalized.contains('cap')) {
    return ProductCategory.hats;
  }

  return switch (id) {
    1 => ProductCategory.tshirts,
    2 => ProductCategory.hoodies,
    3 => ProductCategory.mugs,
    4 => ProductCategory.accessories,
    5 => ProductCategory.stickers,
    6 => ProductCategory.hats,
    _ => ProductCategory.accessories,
  };
}

int _discountPercent(double price, double originalPrice) {
  if (price <= 0 || originalPrice <= price) return 0;
  return (((originalPrice - price) / originalPrice) * 100).round();
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
