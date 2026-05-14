import 'package:athar/features/shopping/presentation/cubit/shopping_cubit.dart';
import 'package:athar/features/shopping/presentation/cubit/shopping_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/custom_text.dart';

class ShoppingAppBar extends StatelessWidget {
  const ShoppingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'المتجر',
                  variant: TextVariant.headingMedium,
                  tone: TextTone.primary,
                ),
                const SizedBox(height: 4),
                BlocSelector<ShoppingCubit, ShoppingState, int>(
                  selector: (state) => state.filteredProducts.length,
                  builder: (context, count) {
                    return CustomText(
                      'متاح $count منتج',
                      variant: TextVariant.labelSmall,
                      tone: TextTone.secondary,
                    );
                  },
                ),
              ],
            ),
          ),
          // View toggle
          BlocSelector<ShoppingCubit, ShoppingState, ViewMode>(
            selector: (state) => state.viewMode,
            builder: (context, viewMode) {
              return Row(
                children: [
                  _IconButton(
                    icon: Icons.grid_view,
                    isActive: viewMode == ViewMode.grid,
                    onTap: () {
                      if (viewMode != ViewMode.grid) {
                        context.read<ShoppingCubit>().toggleViewMode();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _IconButton(
                    icon: Icons.view_list,
                    isActive: viewMode == ViewMode.list,
                    onTap: () {
                      if (viewMode != ViewMode.list) {
                        context.read<ShoppingCubit>().toggleViewMode();
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
          // Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  color: AppColors.darkTextPrimary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                CustomText(
                  'فلترة',
                  variant: TextVariant.labelSmall,
                  tone: TextTone.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.neonBlue : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.darkTextSecondary,
          size: 18,
        ),
      ),
    );
  }
}
