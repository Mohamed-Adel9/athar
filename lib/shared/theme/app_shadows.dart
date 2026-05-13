import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> strong = [
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.18),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];
}
