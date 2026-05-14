
import 'package:flutter/material.dart';

@immutable
class ProductFeature {
  const ProductFeature({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductFeature && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
}