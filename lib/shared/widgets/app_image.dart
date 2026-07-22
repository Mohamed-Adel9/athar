import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icon = Icons.image_outlined,
  });

  final String? source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final value = source?.trim() ?? '';
    if (value.isEmpty) {
      return _ImageFallback(width: width, height: height, icon: icon);
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(
        value,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            _ImageFallback(width: width, height: height, icon: icon),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _ImageFallback(
            width: width,
            height: height,
            icon: icon,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    return Image.asset(
      value,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          _ImageFallback(width: width, height: height, icon: icon),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({
    required this.icon,
    this.width,
    this.height,
    this.child,
  });

  final IconData icon;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.darkSurface.withValues(alpha: .85),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: AppColors.darkTextSecondary, size: 28),
    );
  }
}
