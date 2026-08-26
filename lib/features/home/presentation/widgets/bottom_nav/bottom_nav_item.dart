import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/theme/app_spacing.dart';
import 'bottom_nav_tab.dart';

class BottomNavItem extends StatelessWidget {
  final NavItem item;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.item,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.neonBlue.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: AnimatedSwitcher(
              duration: 200.ms,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive
                    ? AppColors.neonBlue
                    : AppColors.textPrimary(context),
                size: AppSpacing.md,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: 200.ms,
            child: CustomText(
              label,
              variant: TextVariant.captionMedium,
              tone: isActive ? TextTone.neonBlue : TextTone.primary,
            ),
          ),
        ],
      ),
    );
  }
}
