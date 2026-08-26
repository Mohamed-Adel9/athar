import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_spacing.dart';

class AppInput extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
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
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final surface = AppColors.surface(context);
    final border = AppColors.border(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            IconTheme(
              data: IconThemeData(color: textSecondary, size: 20),
              child: prefixIcon!,
            ),
            const SizedBox(width: 12),
          ],

          // ✏️ TextField
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 14,
              ).copyWith(color: textPrimary),
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,

                hintStyle: TextStyle(color: textSecondary, fontSize: 14),
              ),
            ),
          ),

          if (suffixIcon != null) ...[const SizedBox(width: 8), suffixIcon!],
        ],
      ),
    );
  }
}
