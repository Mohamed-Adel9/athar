import 'package:athar/shared/theme/app_color.dart';
import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../../shared/theme/app_spacing.dart';
import '../../data/models/wishlist_item_model.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItemModel item;
  final VoidCallback onRemove;
  final VoidCallback onCart;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(item.image, fit: BoxFit.cover),
                ),
                // out of stock
                if (!item.inStock)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .55),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Center(
                      child: CustomText(
                        'غير متوفر حالياً',
                        variant: TextVariant.bodyMedium,
                      ),
                    ),
                  ),

                //remove
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: AppSpacing.lg,
                      height: AppSpacing.lg,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        variant: TextVariant.labelMedium,
                      ),

                      const SizedBox(height: 8),
                      CustomText(
                        'EGP ${item.price.toStringAsFixed(0)}',
                        variant: TextVariant.bodyMedium,
                        tone: TextTone.neonBlue,
                      ),
                    ],
                  ),
                ),

                if (item.inStock)
                  GestureDetector(
                    onTap: onCart,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.neonBlue.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
