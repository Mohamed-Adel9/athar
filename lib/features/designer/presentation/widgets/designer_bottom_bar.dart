import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_shadows.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/designer_cubit.dart';

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
            // In DesignerBottomBar
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final cubit = context.read<DesignerCubit>();
                  final state = cubit.state;

                  // Add current design to cart
                  context.read<CartCubit>().addItem(
                    CartItemModel(
                      id: 'design-${DateTime.now().millisecondsSinceEpoch}',
                      name: '${state.selectedProduct!.title} مُخصص',
                      price: 299, // or dynamic pricing
                      quantity: 1,
                      imageUrl: state.selectedProduct!.mockUpImage,
                      color: 'أبيض', // from product
                      size: 'M', // from selection
                    ),
                  );

                  // Navigate to cart
                  context.go('/cart');
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
