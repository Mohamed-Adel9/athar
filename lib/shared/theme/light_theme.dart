import 'package:athar/shared/theme/styles.dart';
import 'package:flutter/material.dart';

import 'app_color.dart';

class LightTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    textTheme: AppTypography.textTheme,

    scaffoldBackgroundColor: AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
    ),

    cardColor: AppColors.lightSurface,
    dividerColor: AppColors.lightBorder,
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
  );
}
