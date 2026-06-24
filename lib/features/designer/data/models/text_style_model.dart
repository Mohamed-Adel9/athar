import 'package:flutter/material.dart';

class TextStyleModel {
  const TextStyleModel({
    required this.fontFamily,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.color,
    required this.letterSpacing,
    required this.lineHeight,
  });

  final String fontFamily;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final Color color;
  final double letterSpacing;
  final double lineHeight;

  static const TextStyleModel initial = TextStyleModel(
    fontFamily: 'Poppins',
    fontSize: 28,
    isBold: true,
    isItalic: false,
    color: Colors.white,
    letterSpacing: 0,
    lineHeight: 1,
  );

  TextStyleModel copyWith({
    String? fontFamily,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    Color? color,
    double? letterSpacing,
    double? lineHeight,
  }) {
    return TextStyleModel(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      color: color ?? this.color,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextStyleModel &&
          runtimeType == other.runtimeType &&
          fontFamily == other.fontFamily &&
          fontSize == other.fontSize &&
          isBold == other.isBold &&
          isItalic == other.isItalic &&
          color == other.color &&
          letterSpacing == other.letterSpacing &&
          lineHeight == other.lineHeight;

  @override
  int get hashCode => Object.hash(
    fontFamily,
    fontSize,
    isBold,
    isItalic,
    color,
    letterSpacing,
    lineHeight,
  );

  @override
  String toString() =>
      'TextStyleModel(font: $fontFamily, size: $fontSize, bold: $isBold)';
}
