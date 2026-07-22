import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/designer_cubit.dart';
import 'saved_designs_dialog.dart';

class DesignerHeader extends StatelessWidget {
  const DesignerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomText(
              'أنشئ تصميم',
              variant: TextVariant.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _HeaderAction(
                    text: 'احفظ',
                    onPressed: cubit.saveDesign,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _HeaderAction(
                    text: 'عرض',
                    onPressed: cubit.togglePreviewMode,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _HeaderAction(
                    text: 'المحفوظات',
                    onPressed: () => _showSavedDesigns(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: -.2);
  }

  void _showSavedDesigns(BuildContext context) {
    final cubit = context.read<DesignerCubit>()..fetchSavedDesigns();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SavedDesignsDialog(),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomText(text, variant: TextVariant.labelSmall),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
