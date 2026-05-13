import 'package:flutter/material.dart';

abstract class Styles {
  // Dynamic TextStyle Getters
  static TextStyle get textStyle100 => _baseStyle(FontWeight.w100);
  static TextStyle get textStyle200 => _baseStyle(FontWeight.w200);
  static TextStyle get textStyle300 => _baseStyle(FontWeight.w300);
  static TextStyle get textStyle400 => _baseStyle(FontWeight.w400);
  static TextStyle get textStyle500 => _baseStyle(FontWeight.w500);
  static TextStyle get textStyle600 => _baseStyle(FontWeight.w600);
  static TextStyle get textStyle700 => _baseStyle(FontWeight.w700);
  static TextStyle get textStyle800 => _baseStyle(FontWeight.w800);
  static TextStyle get textStyle900 => _baseStyle(FontWeight.w900);
  static TextStyle get textStyleBold => _baseStyle(FontWeight.bold);

  static TextStyle _baseStyle(FontWeight weight) {
    return TextStyle(
      fontWeight: weight,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
      fontFamily: "Cairo",
    );
  }
}
