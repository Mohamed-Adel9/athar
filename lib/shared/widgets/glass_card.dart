import 'package:flutter/material.dart';

import '../theme/app_color.dart';

enum GlassCardType { primary, secondary }

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final GlassCardType type;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.type = GlassCardType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isSecondary = type == GlassCardType.secondary;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: isSecondary
            ? AppColors.glassSecondaryGradient
            : AppColors.glassGradient,

        borderRadius: BorderRadius.circular(borderRadius),

        border: Border.all(
          color: isSecondary
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.12),
        ),

        boxShadow: isSecondary
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: child,
    );
  }
}
