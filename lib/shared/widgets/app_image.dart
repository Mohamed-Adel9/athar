import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/const_data/api_urls.dart';
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
        errorBuilder: (_, _, _) =>
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

    final file = File(value);
    if (file.isAbsolute) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) =>
            _ImageFallback(width: width, height: height, icon: icon),
      );
    }

    final networkUrl = _networkUrl(value);
    if (networkUrl != null) {
      return Image.network(
        networkUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) =>
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
      errorBuilder: (_, _, _) =>
          _ImageFallback(width: width, height: height, icon: icon),
    );
  }
}

String? _networkUrl(String value) {
  if (value.startsWith('assets/')) return null;

  final baseUri = Uri.tryParse(ApiUrls.baseUrl);
  if (baseUri == null || !baseUri.hasScheme || baseUri.host.isEmpty) {
    return null;
  }

  final origin = '${baseUri.scheme}://${baseUri.authority}';
  return value.startsWith('/') ? '$origin$value' : '$origin/$value';
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
      color: AppColors.surfaceVariant(context).withValues(alpha: .85),
      alignment: Alignment.center,
      child:
          child ??
          Icon(icon, color: AppColors.textSecondary(context), size: 28),
    );
  }
}
