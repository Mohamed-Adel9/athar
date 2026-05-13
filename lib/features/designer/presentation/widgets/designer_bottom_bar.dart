import 'package:athar/shared/theme/app_shadows.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/designer_cubit.dart';

class DesignerBottomBar extends StatelessWidget {
  const DesignerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: AppShadows.medium,
        ),
        child: Row(
          children: [
            _button(
              icon: Icons.undo,
              onTap: () {
                context.read<DesignerCubit>().undo();
              },
            ),
            _button(
              icon: Icons.redo,
              onTap: () {
                context.read<DesignerCubit>().redo();
              },
            ),
            _button(
              icon: Icons.refresh,
              onTap: () {
                context.read<DesignerCubit>().resetCanvas();
              },
            ),
            SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<DesignerCubit>().saveDesign();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const CustomText(
                    'اضف الي السله',
                    variant: TextVariant.labelSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.darkTextPrimary.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
