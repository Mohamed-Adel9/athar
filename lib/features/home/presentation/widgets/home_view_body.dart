import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_search_bar.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/home_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import 'bottom_nav/bottom_nav_tab.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.onNavigate});

  final ValueChanged<BottomNavTab> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading &&
              state.data.products.isEmpty) {
            return const _HomeLoading();
          }

          if (state.status == HomeStatus.failure &&
              state.data.products.isEmpty) {
            return _HomeError(message: state.errorMessage);
          }

          return RefreshIndicator(
            onRefresh: context.read<HomeCubit>().fetchHome,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _HomeHeader(onNavigate: onNavigate),
                      const SizedBox(height: AppSpacing.md),
                      CustomSearchBar(
                        onChanged: context.read<HomeCubit>().search,
                      ),
                      if (state.searchQuery.trim().isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _ProductsSection(
                          title: 'نتائج البحث',
                          products: state.visibleProducts,
                          showEmpty: true,
                          onViewAll: () => onNavigate(BottomNavTab.shop),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      _HeroSlider(sliders: state.data.sliders),
                      const SizedBox(height: AppSpacing.md),
                      _BannerStrip(banners: state.data.banners),
                      const SizedBox(height: AppSpacing.lg),
                      _InspirationCard(onNavigate: onNavigate),
                      const SizedBox(height: AppSpacing.lg),
                      _ProductsSection(
                        title: 'منتجات مميزة',
                        products: state.featuredProducts.take(6).toList(),
                        onViewAll: () => onNavigate(BottomNavTab.shop),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _WhyAtharSection(onNavigate: onNavigate),
                      const SizedBox(height: AppSpacing.lg),
                      _ReviewsSection(reviews: state.data.reviews),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onNavigate});

  final ValueChanged<BottomNavTab> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText('أهلا بك في ', variant: TextVariant.headingSmall),
                  CustomText(
                    " أثر",
                    variant: TextVariant.headingLarge,
                    tone: TextTone.neonBlue,
                    gradient: AppColors.primaryGradient,
                    fontFamily: 'Noto Nastaliq Urdu',
                  ),
                ],
              ),
              SizedBox(height: 4),
              CustomText(
                'اكتشف المنتجات وصمم طلبك بطريقتك',
                variant: TextVariant.bodyMedium,
                tone: TextTone.secondary,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onNavigate(BottomNavTab.profile),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _HeroSlider extends StatelessWidget {
  const _HeroSlider({required this.sliders});

  final List<HomeSliderEntity> sliders;

  @override
  Widget build(BuildContext context) {
    if (sliders.isEmpty) return const _FallbackHero();

    return SizedBox(
      height: 210,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: sliders.length,
        itemBuilder: (context, index) {
          final slider = sliders[index];
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _NetworkImage(url: slider.imageUrl),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: .70),
                          Colors.black.withValues(alpha: .16),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          slider.displayTitle,
                          variant: TextVariant.headingSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (slider.displayText.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          CustomText(
                            slider.displayText,
                            variant: TextVariant.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FallbackHero extends StatelessWidget {
  const _FallbackHero();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      child: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText('صمم منتجك الآن', variant: TextVariant.headingSmall),
            SizedBox(height: AppSpacing.sm),
            CustomText(
              'أضف النصوص والصور والملصقات على منتجاتك المفضلة.',
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerStrip extends StatelessWidget {
  const _BannerStrip({required this.banners});

  final List<HomeBannerEntity> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 220,
              child: _NetworkImage(url: banners[index].imageUrl),
            ),
          );
        },
      ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({required this.onNavigate});

  final ValueChanged<BottomNavTab> onNavigate;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.neonBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: CustomText(
                  'فكرة اليوم',
                  variant: TextVariant.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const CustomText(
            'حوّل صورة أو عبارة تحبها إلى منتج خاص بك خلال دقائق.',
            variant: TextVariant.bodyMedium,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'ابدأ التصميم',
            height: 42,
            isFullWidth: true,
            onPressed: () => onNavigate(BottomNavTab.designer),
          ),
        ],
      ),
    );
  }
}

class _WhyAtharSection extends StatelessWidget {
  const _WhyAtharSection({required this.onNavigate});

  final ValueChanged<BottomNavTab> onNavigate;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('اطلب منتج يشبهك', variant: TextVariant.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const CustomText(
            'اختار المنتج، أضف فكرتك، وخلينا نحولها لقطعة جاهزة بتفاصيلك.',
            variant: TextVariant.bodyMedium,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Expanded(
                child: _FeaturePill(
                  icon: Icons.palette_outlined,
                  text: 'تصميم خاص',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: _FeaturePill(
                  icon: Icons.verified_outlined,
                  text: 'جودة مضمونة',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Expanded(
                child: _FeaturePill(
                  icon: Icons.local_shipping_outlined,
                  text: 'توصيل سريع',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  text: 'صمم الآن',
                  height: 44,
                  isFullWidth: true,
                  onPressed: () => onNavigate(BottomNavTab.designer),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface(context).withValues(alpha: .88),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.neonBlue, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: CustomText(
              text,
              variant: TextVariant.captionSmall,
              tone: TextTone.primary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({
    required this.title,
    required this.products,
    required this.onViewAll,
    this.showEmpty = false,
  });

  final String title;
  final List<HomeProductEntity> products;
  final VoidCallback onViewAll;
  final bool showEmpty;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && !showEmpty) return const SizedBox.shrink();
    final itemCount = products.length > 4 ? 4 : products.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(title, variant: TextVariant.titleMedium),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const CustomText(
                'عرض الكل',
                variant: TextVariant.labelSmall,
                tone: TextTone.neonBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (products.isEmpty)
          const _EmptyProducts()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: .64,
            ),
            itemBuilder: (context, index) {
              return _HomeProductCard(product: products[index]);
            },
          ),
      ],
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  const _HomeProductCard({required this.product});

  final HomeProductEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home-product-details', extra: product),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: _NetworkImage(url: product.imageUrl),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _IconBubble(
                      icon: Icons.favorite_border,
                      onTap: () {},
                    ),
                  ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _Badge(text: '-${product.discountPercent}%'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    product.displayName,
                    variant: TextVariant.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    product.category?.displayTitle ?? product.size,
                    variant: TextVariant.captionSmall,
                    tone: TextTone.secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          '${product.price.toStringAsFixed(0)} ج.م',
                          variant: TextVariant.labelMedium,
                          tone: TextTone.neonBlue,
                          maxLines: 1,
                        ),
                      ),
                      if (product.hasDiscount)
                        CustomText(
                          product.oldPrice.toStringAsFixed(0),
                          variant: TextVariant.captionSmall,
                          tone: TextTone.muted,
                          decoration: TextDecoration.lineThrough,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});

  final List<HomeReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: CustomText(
                'آراء العملاء',
                variant: TextVariant.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/review'),
              icon: const Icon(
                Icons.rate_review_outlined,
                color: AppColors.neonBlue,
                size: 18,
              ),
              label: const CustomText(
                'أضف رأيك',
                variant: TextVariant.labelSmall,
                tone: TextTone.neonBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _AddReviewPrompt(onTap: () => context.push('/review')),
        if (reviews.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 142,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return SizedBox(
                  width: 280,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.neonBlue.withValues(
                                alpha: .25,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.neonBlue,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: CustomText(
                                review.displayName,
                                variant: TextVariant.labelMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            CustomText(
                              '${review.rating}',
                              variant: TextVariant.captionSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        CustomText(
                          review.displayText,
                          variant: TextVariant.bodySmall,
                          tone: TextTone.secondary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _AddReviewPrompt extends StatelessWidget {
  const _AddReviewPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.favorite_border, color: AppColors.neonBlue),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText('رأيك يفرق معنا', variant: TextVariant.bodyMedium),
                SizedBox(height: 4),
                CustomText(
                  'شارك تجربتك وساعد غيرك يختار بثقة.',
                  variant: TextVariant.captionSmall,
                  tone: TextTone.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            text: 'اكتب رأيك',
            height: 40,
            isFullWidth: false,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({required this.url, this.icon = Icons.image_outlined});

  final String? url;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _ImageFallback(icon: icon);

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _ImageFallback(icon: icon),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _ImageFallback(
          icon: icon,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.icon, this.child});

  final IconData icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkSurface.withValues(alpha: .85),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: AppColors.darkTextSecondary, size: 28),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: CustomText(text, variant: TextVariant.captionSmall),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      child: SizedBox(
        height: 110,
        child: Center(
          child: CustomText(
            'لا توجد منتجات مطابقة',
            variant: TextVariant.bodyMedium,
            tone: TextTone.secondary,
          ),
        ),
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                color: AppColors.error,
                size: 42,
              ),
              const SizedBox(height: AppSpacing.md),
              const CustomText(
                'تعذر تحميل الصفحة الرئيسية',
                variant: TextVariant.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              CustomText(
                message ?? 'حاول مرة أخرى بعد لحظات.',
                variant: TextVariant.bodySmall,
                tone: TextTone.secondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'إعادة المحاولة',
                isFullWidth: true,
                onPressed: context.read<HomeCubit>().fetchHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
