import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/home_entity.dart';

class HomeProductDetailsView extends StatelessWidget {
  const HomeProductDetailsView({super.key, required this.product});

  final HomeProductEntity? product;

  @override
  Widget build(BuildContext context) {
    final item = product;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.darkTextPrimary),
        ),
        title: const CustomText(
          'تفاصيل المنتج',
          variant: TextVariant.titleMedium,
        ),
      ),
      body: item == null
          ? const _MissingProduct()
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: AppImage(source: item.imageUrl),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          item.displayName,
                          variant: TextVariant.headingMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.discountPercent > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: CustomText(
                            '-${item.discountPercent}%',
                            variant: TextVariant.captionSmall,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomText(
                    item.category?.displayTitle ?? 'منتج مخصص',
                    variant: TextVariant.bodyMedium,
                    tone: TextTone.secondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GlassCard(
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'السعر',
                          value: '${item.price.toStringAsFixed(0)} ج.م',
                          valueTone: TextTone.neonBlue,
                        ),
                        if (item.hasDiscount)
                          _DetailRow(
                            label: 'قبل الخصم',
                            value: '${item.oldPrice.toStringAsFixed(0)} ج.م',
                          ),
                        if (item.size.isNotEmpty)
                          _DetailRow(label: 'المقاس', value: item.size),
                        _DetailRow(
                          label: 'الكمية المتاحة',
                          value: '${item.quantity}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const CustomText(
                    'اختر هذا المنتج كنقطة بداية، ثم أضف لمستك الخاصة من النصوص والصور والملصقات.',
                    variant: TextVariant.bodyMedium,
                    tone: TextTone.secondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'ابدأ التصميم عليه',
                    icon: const Icon(Icons.brush_outlined, color: Colors.white),
                    onPressed: () => context.push('/designer'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueTone = TextTone.primary,
  });

  final String label;
  final String value;
  final TextTone valueTone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              label,
              variant: TextVariant.bodyMedium,
              tone: TextTone.secondary,
            ),
          ),
          CustomText(value, variant: TextVariant.bodyMedium, tone: valueTone),
        ],
      ),
    );
  }
}

class _MissingProduct extends StatelessWidget {
  const _MissingProduct();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.darkTextSecondary,
                size: 42,
              ),
              const SizedBox(height: AppSpacing.md),
              const CustomText(
                'لم يتم العثور على المنتج',
                variant: TextVariant.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'العودة',
                height: 44,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
