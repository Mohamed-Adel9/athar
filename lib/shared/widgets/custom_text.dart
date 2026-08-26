import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color.dart';
import '../theme/styles.dart';

enum TextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headingLarge,
  headingMedium,
  headingSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  captionLarge,
  captionMedium,
  captionSmall,
}

enum TextTone {
  primary,
  secondary,
  inverse,
  error,
  success,
  warning,
  neonBlue,
  muted,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final TextTone tone;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final double? height;
  final Gradient? gradient;
  final TextDecoration? decoration;
  final String? fontFamily;

  const CustomText(
    this.text, {
    super.key,
    this.variant = TextVariant.bodyMedium,
    this.tone = TextTone.primary,
    this.maxLines,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.gradient,
    this.fontFamily,
    this.overflow,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = _getStyle();
    final color = _getColor(context);

    TextStyle finalStyle = baseStyle.copyWith(
      color: gradient == null ? color : Colors.white,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

    // Apply Google Font if provided
    if (fontFamily != null) {
      finalStyle = GoogleFonts.getFont(fontFamily!, textStyle: finalStyle);
    }

    final textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: finalStyle,
      overflow: overflow,
    );

    // Gradient support
    if (gradient == null) return textWidget;

    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: textWidget,
    );
  }

  TextStyle _getStyle() {
    final textTheme = AppTypography.textTheme;

    switch (variant) {
      case TextVariant.displayLarge:
        return textTheme.displayLarge ?? const TextStyle();

      case TextVariant.displayMedium:
        return textTheme.displayMedium ?? const TextStyle();

      case TextVariant.displaySmall:
        return textTheme.displaySmall ?? const TextStyle();

      case TextVariant.headingLarge:
        return textTheme.headlineLarge ?? const TextStyle();

      case TextVariant.headingMedium:
        return textTheme.headlineMedium ?? const TextStyle();

      case TextVariant.headingSmall:
        return textTheme.headlineSmall ?? const TextStyle();

      case TextVariant.titleLarge:
        return textTheme.titleLarge ?? const TextStyle();

      case TextVariant.titleMedium:
        return textTheme.titleMedium ?? const TextStyle();

      case TextVariant.titleSmall:
        return textTheme.titleSmall ?? const TextStyle();

      case TextVariant.bodyLarge:
        return textTheme.bodyLarge ?? const TextStyle();

      case TextVariant.bodyMedium:
        return textTheme.bodyMedium ?? const TextStyle();

      case TextVariant.bodySmall:
        return textTheme.bodySmall ?? const TextStyle();

      case TextVariant.labelLarge:
        return textTheme.labelLarge ?? const TextStyle();

      case TextVariant.labelMedium:
        return textTheme.labelMedium ?? const TextStyle();

      case TextVariant.labelSmall:
        return textTheme.labelSmall ?? const TextStyle();

      case TextVariant.captionLarge:
        return textTheme.bodyMedium ?? const TextStyle();

      case TextVariant.captionMedium:
        return textTheme.bodySmall ?? const TextStyle();

      case TextVariant.captionSmall:
        return textTheme.labelSmall ?? const TextStyle();
    }
  }

  Color _getColor(BuildContext context) {
    switch (tone) {
      case TextTone.primary:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary;

      case TextTone.secondary:
        return Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;

      case TextTone.inverse:
        return Colors.white;

      case TextTone.muted:
        return Colors.grey;

      case TextTone.error:
        return AppColors.error;

      case TextTone.success:
        return AppColors.success;

      case TextTone.warning:
        return AppColors.warning;

      case TextTone.neonBlue:
        return AppColors.neonBlue;
    }
  }
}
