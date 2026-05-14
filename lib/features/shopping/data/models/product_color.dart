import 'package:flutter/material.dart';

@immutable
class ProductColor {
  const ProductColor({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductColor &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
