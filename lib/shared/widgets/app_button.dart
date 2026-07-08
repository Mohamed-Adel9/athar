import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isSecondary;
  final bool isFullWidth;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isFullWidth = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: isSecondary ? _buildSecondaryButton() : _buildPrimaryButton(),
    );
  }

  Widget _buildPrimaryButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text,
                    variant: TextVariant.bodyMedium,
                    tone: TextTone.primary,
                  ),
                  if (icon != null) ...[const SizedBox(width: 8), icon!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    final style = OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.darkBorder),
      backgroundColor: AppColors.darkSurface.withValues(alpha: .5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: icon!,
        label: CustomText(
          text,
          variant: TextVariant.bodyMedium,
          tone: TextTone.primary,
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: CustomText(
        text,
        variant: TextVariant.bodyMedium,
        tone: TextTone.primary,
      ),
    );
  }
}
