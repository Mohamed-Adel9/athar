import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // ---------- FONTS ----------
  static TextStyle arabic({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.alexandria(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle luxury({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.elMessiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ---------- TEXT THEME ----------
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.elMessiri(
      fontSize: 40,
      fontWeight: FontWeight.w800,
    ),
    displayMedium: GoogleFonts.elMessiri(
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: GoogleFonts.elMessiri(
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),

    headlineLarge: GoogleFonts.alexandria(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: GoogleFonts.alexandria(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.alexandria(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    bodyLarge: GoogleFonts.alexandria(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.alexandria(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.alexandria(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),

    labelLarge: GoogleFonts.alexandria(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.alexandria(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading() => AppTypography.textTheme.headlineLarge!;

  static TextStyle title() => AppTypography.textTheme.headlineMedium!;

  static TextStyle body() => AppTypography.textTheme.bodyLarge!;

  static TextStyle caption() => AppTypography.textTheme.bodySmall!;
}
