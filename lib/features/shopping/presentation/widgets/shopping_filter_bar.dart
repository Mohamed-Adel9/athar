import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../data/models/product_category.dart';
import '../cubit/shopping_cubit.dart';
import '../cubit/shopping_state.dart';

class ShoppingFilterBar extends StatelessWidget {
  const ShoppingFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: ProductCategory.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final category = ProductCategory.values[index];
              final isSelected = state.selectedCategory == category;

              return InkWell(
                onTap: () =>
                    context.read<ShoppingCubit>().selectCategory(category),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.darkBorder),
                  ),
                  child: CustomText(
                    category.displayName,
                    variant: TextVariant.labelMedium,
                    tone: isSelected ? TextTone.primary : TextTone.secondary,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
