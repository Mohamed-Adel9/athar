import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../wishlist/data/models/wishlist_item_model.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_states.dart';
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
                child: AppImage(source: product.imageUrl),
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
              Positioned(
                top: 8,
                right: 8,
                child: _FavoriteButton(product: product),
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
                    Expanded(
                      child: CustomText(
                        '${product.price.toStringAsFixed(0)} ج.م',
                        variant: TextVariant.labelLarge,
                        tone: TextTone.neonBlue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.discountPercent > 0)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6),
                          child: CustomText(
                            '${product.originalPrice.toStringAsFixed(0)} ج.م',
                            variant: TextVariant.labelSmall,
                            decoration: TextDecoration.lineThrough,
                            tone: TextTone.muted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
          child: AppImage(
            source: product.imageUrl,
            width: 120,
            height: 120,
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
                    Flexible(
                      child: CustomText(
                        '${product.price.toStringAsFixed(0)} ج.م',
                        variant: TextVariant.bodyMedium,
                        tone: TextTone.neonBlue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.discountPercent > 0)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: CustomText(
                            '${product.originalPrice.toStringAsFixed(0)} ج.م',
                            variant: TextVariant.labelSmall,
                            tone: TextTone.muted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 10, bottom: 10),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _FavoriteButton(product: product),
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final itemId = _wishlistItemId(product);

    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (state) => state.items.any((item) => item.id == itemId),
      builder: (context, isFavorite) {
        return GestureDetector(
          onTap: () {
            final added = context.read<WishlistCubit>().toggleItem(
              _wishlistItemFromProduct(product),
            );

            SnackBarService.success(
              context: context,
              message: added
                  ? 'تمت الإضافة إلى المفضلة'
                  : 'تمت الإزالة من المفضلة',
            );
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface(context).withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? AppColors.error
                  : AppColors.textPrimary(context),
              size: 19,
            ),
          ),
        );
      },
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

WishlistItemModel _wishlistItemFromProduct(ProductModel product) {
  return WishlistItemModel(
    id: _wishlistItemId(product),
    productId: int.tryParse(product.id),
    title: product.name,
    price: product.price,
    image: product.imageUrl,
    inStock: true,
  );
}

int _wishlistItemId(ProductModel product) {
  return int.tryParse(product.id) ?? product.id.hashCode;
}
