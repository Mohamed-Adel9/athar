import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../shopping/data/models/product_model.dart';
import '../../../shopping/presentation/cubit/shopping_cubit.dart';
import '../../../shopping/presentation/cubit/shopping_state.dart';
import '../../../shopping/presentation/widgets/product_card.dart';
import '../../../shopping/presentation/widgets/product_details_sheet.dart';
import '../cubit/home_cubit.dart';
import 'bottom_nav/bottom_nav_tab.dart';

class ProductPreviewSection extends StatelessWidget {
  const ProductPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        final previewProducts = state.products.take(4).toList();

        if (previewProducts.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'منتجات مميزة',
                    variant: TextVariant.titleMedium,
                    tone: TextTone.primary,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<HomeCubit>().changeTab(BottomNavTab.shop);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'عرض الكل',
                          variant: TextVariant.labelSmall,
                          tone: TextTone.neonBlue,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.neonBlue,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 2x2 Grid Preview
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemCount: previewProducts.length,
                itemBuilder: (_, index) => ProductCard(
                  product: previewProducts[index],
                  onTap: () {
                    _showProductDetails(context, previewProducts[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, ProductModel product) {
    final shopCubit = context.read<ShoppingCubit>();
    shopCubit.selectProduct(product);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: shopCubit,
        child: const ProductDetailsSheet(),
      ),
    );
  }
}
