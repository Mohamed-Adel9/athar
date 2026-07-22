import 'package:flutter/material.dart';

@immutable
class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.color,
    required this.size,
    this.isCustomDesign = false,
    this.designData,
  });

  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String color;
  final String size;
  final bool isCustomDesign;
  final Map<String, dynamic>? designData;

  double get total => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? color,
    String? size,
    bool? isCustomDesign,
    Map<String, dynamic>? designData,
    bool clearDesignData = false,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      size: size ?? this.size,
      isCustomDesign: isCustomDesign ?? this.isCustomDesign,
      designData: clearDesignData ? null : (designData ?? this.designData),
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
