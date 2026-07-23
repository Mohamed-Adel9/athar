import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class CartItemModel {
  const CartItemModel({
    required this.id,
    this.productId,
    this.designId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.color,
    required this.size,
    this.isCustomDesign = false,
    this.designData,
    this.previewImageUrl,
  });

  final String id;
  final int? productId;
  final int? designId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String color;
  final String size;
  final bool isCustomDesign;
  final Map<String, dynamic>? designData;
  final String? previewImageUrl;

  double get total => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? DateTime.now().toString(),
      productId: _int(json['product_id']),
      designId: _int(json['design_id']),
      name: json['name']?.toString() ?? '',
      price: _double(json['price']),
      quantity: _int(json['quantity']) ?? 1,
      imageUrl:
          json['image_url']?.toString() ??
          json['imageUrl']?.toString() ??
          json['image']?.toString() ??
          '',
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      isCustomDesign: _bool(json['is_custom_design'] ?? json['isCustomDesign']),
      designData: _nullableMap(json['design_data'] ?? json['designData']),
      previewImageUrl:
          json['preview_image_url']?.toString() ??
          json['previewImageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toCartPayload() {
    return {
      if (productId != null) 'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'color': color,
      'size': size,
      'is_custom_design': isCustomDesign,
      if (designId != null) 'design_id': designId,
      if (designData != null) 'design_data': designData,
      if (previewImageUrl != null) 'preview_image_url': previewImageUrl,
    };
  }

  CartItemModel copyWith({
    String? id,
    int? productId,
    int? designId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? color,
    String? size,
    bool? isCustomDesign,
    Map<String, dynamic>? designData,
    String? previewImageUrl,
    bool clearDesignData = false,
    bool clearPreviewImageUrl = false,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      designId: designId ?? this.designId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      size: size ?? this.size,
      isCustomDesign: isCustomDesign ?? this.isCustomDesign,
      designData: clearDesignData ? null : (designData ?? this.designData),
      previewImageUrl: clearPreviewImageUrl
          ? null
          : (previewImageUrl ?? this.previewImageUrl),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
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
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}

Map<String, dynamic>? _nullableMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
  return null;
}
