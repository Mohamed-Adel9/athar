import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/designer_cubit.dart';

class DesignerHeader extends StatelessWidget {
  const DesignerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            const Expanded(
              child: CustomText('أنشئ تصميم', variant: TextVariant.bodyLarge),
            ),
            SizedBox(
              width: 115,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: 'احفظ تصميمك',
                    height: 40,
                    onPressed: cubit.saveDesign,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    text: 'عرض التصميم',
                    height: 40,
                    onPressed: cubit.togglePreviewMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: -.2);
  }
}
