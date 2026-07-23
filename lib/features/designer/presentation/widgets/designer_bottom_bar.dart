import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_shadows.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';

class DesignerBottomBar extends StatelessWidget {
  const DesignerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignerCubit>();

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
            _ActionButton(icon: Icons.undo, onTap: cubit.undo),
            _ActionButton(icon: Icons.redo, onTap: cubit.redo),
            _ActionButton(icon: Icons.refresh, onTap: cubit.resetCanvas),
            const SizedBox(width: 15),
            Expanded(
              child: BlocSelector<DesignerCubit, DesignerState, bool>(
                selector: (state) => state.isSaving,
                builder: (context, isSaving) {
                  return GestureDetector(
                    onTap: isSaving
                        ? null
                        : () async {
                            final cartItem = await context
                                .read<DesignerCubit>()
                                .addToCart();
                            if (cartItem == null || !context.mounted) return;

                            context.read<CartCubit>().addItem(cartItem);
                            context.go('/cart');
                          },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const CustomText(
                              '\u0623\u0636\u0641 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629',
                              variant: TextVariant.labelSmall,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
