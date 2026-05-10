import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_spacing.dart';

class AppInput extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const AppInput({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            IconTheme(
              data: const IconThemeData(
                color: AppColors.darkTextSecondary,
                size: 20,
              ),
              child: prefixIcon!,
            ),
            const SizedBox(width: 12),
          ],

          // ✏️ TextField
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: AppColors.darkTextPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          if (suffixIcon != null) ...[const SizedBox(width: 8), suffixIcon!],
        ],
      ),
    );
  }
}
