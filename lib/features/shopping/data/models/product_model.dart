import 'package:athar/features/shopping/data/models/product_category.dart';
import 'package:athar/features/shopping/data/models/product_color.dart';
import 'package:athar/features/shopping/data/models/product_feature.dart';
import 'package:athar/features/shopping/data/models/product_review.dart';
import 'package:flutter/material.dart';

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
          other is ProductModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}


