import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/models/product_model.dart';
import '../cubit/shopping_cubit.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isList = false,
    this.onTap,
  });

  final ProductModel product;
  final bool isList;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ?? () => context.read<ShoppingCubit>().selectProduct(product),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: isList ? _buildListLayout() : _buildGridLayout(),
      ),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Expanded(
          flex: 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(product.imageUrl, fit: BoxFit.cover),
              ),
              // Badges
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    if (product.discountPercent > 0)
                      _Badge(
                        text: 'تخفيض ${product.discountPercent}%',
                        color: AppColors.error,
                      ),
                    if (product.isNew) ...[
                      const SizedBox(width: 4),
                      const _Badge(text: 'جديد', color: AppColors.success),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        // Info
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  product.name,
                  variant: TextVariant.labelMedium,
                  tone: TextTone.primary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    CustomText(
                      '${product.rating} (${product.reviewCount})',
                      variant: TextVariant.labelSmall,
                      tone: TextTone.secondary,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      '${product.price.toStringAsFixed(0)} ج.م',
                      variant: TextVariant.labelLarge,
                      tone: TextTone.neonBlue,
                    ),
                    const SizedBox(width: 6),
                    if (product.discountPercent > 0)
                      CustomText(
                        '${product.originalPrice.toStringAsFixed(0)} ج.م',
                        variant: TextVariant.labelSmall,
                        decoration: TextDecoration.lineThrough,
                        tone: TextTone.muted,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout() {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(20),
          ),
          child: Image.asset(
            product.imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        // Info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  product.name,
                  variant: TextVariant.bodyMedium,
                  tone: TextTone.primary,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    CustomText(
                      '${product.rating} (${product.reviewCount})',
                      variant: TextVariant.labelSmall,
                      tone: TextTone.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CustomText(
                      '${product.price.toStringAsFixed(0)} ج.م',
                      variant: TextVariant.bodyMedium,
                      tone: TextTone.neonBlue,
                    ),
                    const SizedBox(width: 8),
                    if (product.discountPercent > 0)
                      CustomText(
                        '${product.originalPrice.toStringAsFixed(0)} ج.م',
                        variant: TextVariant.labelSmall,
                        tone: TextTone.muted,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text,
        variant: TextVariant.labelSmall,
        tone: TextTone.primary,
      ),
    );
  }
}
