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

  factory TextStyleModel.fromJson(Map<String, dynamic> json) {
    return TextStyleModel(
      fontFamily: json['font_family']?.toString() ?? 'Poppins',
      fontSize: _double(json['font_size'], 28),
      isBold: json['is_bold'] == true,
      isItalic: json['is_italic'] == true,
      color: Color(_int(json['color'], Colors.white.toARGB32())),
      letterSpacing: _double(json['letter_spacing'], 0),
      lineHeight: _double(json['line_height'], 1),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'font_family': fontFamily,
      'font_size': fontSize,
      'is_bold': isBold,
      'is_italic': isItalic,
      'color': color.toARGB32(),
      'letter_spacing': letterSpacing,
      'line_height': lineHeight,
    };
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

int _int(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _double(Object? value, double fallback) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}
