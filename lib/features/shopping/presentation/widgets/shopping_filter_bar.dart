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
        final filters = state.filters.isEmpty
            ? [ProductFilter.all()]
            : state.filters;

        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final filter = filters[index];
              final isSelected = state.selectedFilter.key == filter.key;

              return InkWell(
                onTap: () => context.read<ShoppingCubit>().selectFilter(filter),
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
                    filter.title,
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
