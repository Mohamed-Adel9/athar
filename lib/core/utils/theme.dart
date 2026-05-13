// ignore_for_file: deprecated_member_use

import 'styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xff121A77);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color inactiveGrey = Color(0xFF94A3B8);
  static const Color secondaryBlue = Color(0xff0056C5);
  static const Color darkBackground = Color(0xFF0F172A);

  // --- Light Theme ---
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    hintColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light, // iOS: أيقونات سوداء
        statusBarIconBrightness: Brightness.dark, // Android: أيقونات سوداء
      ),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: secondaryBlue,
      surface: Colors.white,
      brightness: Brightness.light,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 10,
      showSelectedLabels: false,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue, // عدلته ليكون واضحاً في الـ Light
      unselectedItemColor: inactiveGrey,
      unselectedLabelStyle: Styles.textStyle400.copyWith(
        color: inactiveGrey,
        fontSize: 12,
      ),
    ),
  );

  // --- Dark Theme ---
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    hintColor: Colors.white70,
    scaffoldBackgroundColor: darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark, // iOS: أيقونات بيضاء
        statusBarIconBrightness: Brightness.light, // Android: أيقونات بيضاء
      ),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: secondaryBlue,
      surface: darkSurface,
      brightness: Brightness.dark,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 10,
      showSelectedLabels: false,
      showUnselectedLabels: true,
      backgroundColor: darkSurface,
      selectedItemColor: Colors.white,
      unselectedItemColor: inactiveGrey.withOpacity(0.6),
      unselectedLabelStyle: Styles.textStyle400.copyWith(
        color: inactiveGrey.withOpacity(0.6),
        fontSize: 12,
      ),
    ),
  );
}
