import 'package:athar/features/shopping/presentation/cubit/shopping_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/data/models/wishlist_item_model.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../data/models/product_color.dart';
import '../../data/models/product_model.dart';
import '../cubit/shopping_cubit.dart';

class ProductDetailsSheet extends StatelessWidget {
  const ProductDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        final product = state.selectedProduct;
        if (product == null) return const SizedBox.shrink();

        return Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: const BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Image Gallery
                    SliverToBoxAdapter(child: _ImageGallery(product: product)),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Title & Price
                    SliverToBoxAdapter(child: _TitleSection(product: product)),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Colors
                    SliverToBoxAdapter(child: _ColorSelector(product: product)),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Sizes
                    SliverToBoxAdapter(child: _SizeSelector(product: product)),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Quantity
                    SliverToBoxAdapter(child: _QuantitySelector()),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Features
                    SliverToBoxAdapter(
                      child: _FeaturesSection(product: product),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Reviews
                    SliverToBoxAdapter(
                      child: _ReviewsSection(product: product),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    SliverToBoxAdapter(child: _AddReviewSection()),
                  ],
                ),
              ),

              // Bottom Bar
              _BottomBar(product: product),
            ],
          ),
        );
      },
    );
  }
}

// ==================== SECTIONS ====================

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ShoppingCubit, ShoppingState, ProductColor?>(
      selector: (state) => state.selectedColor,
      builder: (context, selectedColor) {
        return Column(
          children: [
            // Main Image - Show product image, not color block
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.darkSurface,
              ),
              clipBehavior: Clip.antiAlias,
              child: AppImage(source: product.imageUrl, width: double.infinity),
            ),
            const SizedBox(height: 12),
            // Thumbnails - Show color swatches (not images)
            SizedBox(
              height: 70,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: product.colors.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final color = product.colors[index];
                  final isSelected = selectedColor == color;

                  return GestureDetector(
                    onTap: () =>
                        context.read<ShoppingCubit>().selectColor(color),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.neonBlue
                              : Colors.transparent,
                          width: 2,
                        ),
                        color: color.color,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (product.discountPercent > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    'خصم ${product.discountPercent}%',
                    variant: TextVariant.labelSmall,
                    tone: TextTone.primary,
                  ),
                ),
              if (product.isNew) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CustomText(
                    'جديد',
                    variant: TextVariant.labelSmall,
                    tone: TextTone.primary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            product.name,
            variant: TextVariant.headingMedium,
            tone: TextTone.primary,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(5, (i) {
                return Icon(
                  i < product.rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
              const SizedBox(width: 8),
              CustomText(
                '${product.rating} (${product.reviewCount} تقييم)',
                variant: TextVariant.labelSmall,
                tone: TextTone.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CustomText(
                '${product.price.toStringAsFixed(0)} ج.م',
                variant: TextVariant.displaySmall,
                tone: TextTone.neonBlue,
              ),
              const SizedBox(width: 12),
              if (product.discountPercent > 0)
                CustomText(
                  '${product.originalPrice.toStringAsFixed(0)} ج.م',
                  variant: TextVariant.bodyMedium,
                  tone: TextTone.muted,
                ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            product.description,
            variant: TextVariant.bodyMedium,
            tone: TextTone.secondary,
          ),
        ],
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ShoppingCubit, ShoppingState, ProductColor?>(
      selector: (state) => state.selectedColor,
      builder: (context, selectedColor) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'اللون: ${selectedColor?.name ?? ''}',
                variant: TextVariant.bodyMedium,
                tone: TextTone.primary,
              ),
              const SizedBox(height: 8),
              Row(
                children: product.colors.map((color) {
                  final isSelected = selectedColor == color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () =>
                          context.read<ShoppingCubit>().selectColor(color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.neonBlue
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.neonBlue.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ShoppingCubit, ShoppingState, String?>(
      selector: (state) => state.selectedSize,
      builder: (context, selectedSize) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'المقاس: ${selectedSize ?? ''}',
                variant: TextVariant.bodyMedium,
                tone: TextTone.primary,
              ),
              const SizedBox(height: 8),
              Row(
                children: product.sizes.map((size) {
                  final isSelected = selectedSize == size;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          context.read<ShoppingCubit>().selectSize(size),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.neonBlue
                              : AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.neonBlue
                                : AppColors.darkBorder,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          size,
                          variant: TextVariant.labelMedium,
                          tone: isSelected
                              ? TextTone.primary
                              : TextTone.secondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ShoppingCubit, ShoppingState, int>(
      selector: (state) => state.quantity,
      builder: (context, quantity) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CustomText(
                'الكمية:',
                variant: TextVariant.bodyMedium,
                tone: TextTone.primary,
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () =>
                          context.read<ShoppingCubit>().decrementQuantity(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        '$quantity',
                        variant: TextVariant.bodyMedium,
                        tone: TextTone.primary,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () =>
                          context.read<ShoppingCubit>().incrementQuantity(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.features.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: product.features.map((feature) {
            return Column(
              children: [
                Icon(feature.icon, color: AppColors.neonBlue, size: 24),
                const SizedBox(height: 4),
                CustomText(
                  feature.title,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.primary,
                ),
                CustomText(
                  feature.subtitle,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.secondary,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    if (product.reviews.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'التقييمات',
            variant: TextVariant.titleMedium,
            tone: TextTone.primary,
          ),
          const SizedBox(height: 12),
          ...product.reviews.map((review) {
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(review.userImage),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            review.userName,
                            variant: TextVariant.labelMedium,
                            tone: TextTone.primary,
                          ),
                          CustomText(
                            review.date,
                            variant: TextVariant.labelSmall,
                            tone: TextTone.secondary,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    review.comment,
                    variant: TextVariant.bodySmall,
                    tone: TextTone.secondary,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Wishlist
            _IconActionButton(
              icon: Icons.favorite_border,
              onTap: () {
                final auth = context.read<AuthCubit>();
                auth.requireAuth(() {
                  final item = WishlistItemModel(
                    id: int.tryParse(product.id) ?? 0,
                    title: product.name,
                    price: product.price.toDouble(),
                    inStock: true,
                    image: product.imageUrl,
                  );
                  context.read<WishlistCubit>().addToCart(item);
                  SnackBarService.success(
                    context: context,
                    message: 'تمت الإضافة إلى المفضلة',
                  );
                });
              },
            ),
            const SizedBox(width: 8),
            // Share
            _IconActionButton(
              icon: Icons.share_outlined,
              onTap: () {
                // TODO: Implement share functionality
                SnackBarService.success(
                  context: context,
                  message: 'مشاركة المنتج',
                );
              },
            ),
            const SizedBox(width: 12),
            // Add to Cart
            Expanded(
              child: BlocBuilder<ShoppingCubit, ShoppingState>(
                builder: (context, state) {
                  return AppButton(
                    text: 'أضف إلى السلة',
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: state.canAddToCart
                        ? () {
                            final cartItem = CartItemModel(
                              id: '${product.id}-${state.selectedColor!.name}-${state.selectedSize}',
                              name: product.name,
                              price: product.price,
                              quantity: state.quantity,
                              imageUrl: product
                                  .imageUrl, // FIXED: Use actual image, not color
                              color: state.selectedColor!.name,
                              size: state.selectedSize!,
                            );

                            // Add to cart
                            context.read<CartCubit>().addItem(cartItem);

                            // Close sheet
                            Navigator.pop(context);

                            // Show success snackbar (NOT navigate to checkout)
                            SnackBarService.success(
                              context: context,
                              message: 'تمت إضافة المنتج إلى السلة بنجاح',
                            );
                          }
                        : null,
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

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.darkTextPrimary, size: 16),
        ),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Icon(icon, color: AppColors.darkTextPrimary, size: 20),
      ),
    );
  }
}

class _AddReviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'أضف تقييمك',
                  variant: TextVariant.titleMedium,
                  tone: TextTone.primary,
                ),

                const SizedBox(height: 16),

                Row(
                  children: List.generate(5, (index) {
                    final rating = index + 1;

                    return GestureDetector(
                      onTap: () {
                        context.read<ShoppingCubit>().changeRating(rating);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          rating <= state.selectedRating!
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 28,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: context.read<ShoppingCubit>().reviewController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'اكتب رأيك عن المنتج...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.darkSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'إرسال التقييم',
                    onPressed: () {
                      context.read<ShoppingCubit>().addReview();

                      SnackBarService.success(
                        context: context,
                        message: 'تم إضافة التقييم بنجاح',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
