import 'package:flutter/material.dart';

import '../../shared/theme/app_color.dart';
import '../../shared/theme/app_radius.dart';
import '../../shared/theme/app_spacing.dart';

class SnackBarService {
  static void success({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBar(
        backgroundColor: AppColors.success,
        icon: Icons.check_circle_outline,
        message: message,
      ),
    );
  }

  static void failure({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBar(
        backgroundColor: AppColors.error,
        icon: Icons.error_outline,
        message: message,
      ),
    );
  }
}

SnackBar _snackBar({
  required Color backgroundColor,
  required IconData icon,
  required String message,
}) {
  return SnackBar(
    elevation: 10,
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    margin: const EdgeInsets.all(AppSpacing.md),
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
    closeIconColor: Colors.white,
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}
