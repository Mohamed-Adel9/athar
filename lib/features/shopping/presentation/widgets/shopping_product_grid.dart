import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/models/product_model.dart';
import '../cubit/shopping_cubit.dart';
import '../cubit/shopping_state.dart';
import 'product_card.dart';

class ShoppingProductGrid extends StatelessWidget {
  const ShoppingProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        final products = state.filteredProducts;

        if (state.status == ShopStatus.loading && products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == ShopStatus.error && products.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_outlined,
                    color: AppColors.error,
                    size: 42,
                  ),
                  const SizedBox(height: 16),
                  const CustomText(
                    'Could not load products',
                    variant: TextVariant.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    state.errorMessage ?? 'Please try again.',
                    variant: TextVariant.bodySmall,
                    tone: TextTone.secondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Retry',
                    isFullWidth: true,
                    onPressed: () =>
                        context.read<ShoppingCubit>().fetchProducts(),
                  ),
                ],
              ),
            ),
          );
        }

        if (products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CustomText(
                'لا توجد منتجات في هذا القسم',
                variant: TextVariant.bodyMedium,
                tone: TextTone.secondary,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: state.viewMode == ViewMode.grid
              ? _buildGrid(products)
              : _buildList(products),
        );
      },
    );
  }

  Widget _buildGrid(List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) => ProductCard(product: products[index]),
    );
  }

  Widget _buildList(List<ProductModel> products) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) =>
          ProductCard(product: products[index], isList: true),
    );
  }
}
