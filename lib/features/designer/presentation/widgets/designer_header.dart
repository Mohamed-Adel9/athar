import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/designer_cubit.dart';
import 'saved_designs_dialog.dart';

class DesignerHeader extends StatelessWidget {
  const DesignerHeader({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface(context).withValues(alpha: .9),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showBackButton) ...[
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _HeaderIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }

                    context.go('/home');
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
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
                    onPressed: () {
                      _saveDesign(context);
                    },
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

  Future<void> _saveDesign(BuildContext context) async {
    final cubit = context.read<DesignerCubit>();
    final result = await cubit.saveDesign();
    if (!context.mounted) return;

    switch (result) {
      case DesignerSaveResult.saved:
        SnackBarService.success(
          context: context,
          message: 'تم حفظ التصميم بنجاح',
        );
      case DesignerSaveResult.duplicate:
        SnackBarService.failure(
          context: context,
          message: 'هذا التصميم محفوظ بالفعل',
        );
      case DesignerSaveResult.failed:
        SnackBarService.failure(
          context: context,
          message: cubit.state.savedDesignsError ?? 'تعذر حفظ التصميم',
        );
    }
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
                child: CustomText(
                  text,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.inverse,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Icon(icon, color: AppColors.textPrimary(context), size: 20),
        ),
      ),
    );
  }
}
