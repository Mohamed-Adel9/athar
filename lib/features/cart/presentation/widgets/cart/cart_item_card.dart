import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_image.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../../data/models/cart_item_model.dart';
import '../../cubit/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              source: item.imageUrl,
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.name,
                  variant: TextVariant.bodyMedium,
                  tone: TextTone.primary,
                ),
                if (item.isCustomDesign) ...[
                  const SizedBox(height: 6),
                  const _CustomDesignChip(),
                ],
                const SizedBox(height: 4),
                CustomText(
                  '\u0627\u0644\u0644\u0648\u0646: ${item.color} | \u0627\u0644\u0645\u0642\u0627\u0633: ${item.size}',
                  variant: TextVariant.labelSmall,
                  tone: TextTone.secondary,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: () => cubit.decrementQuantity(item.id),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CustomText(
                              '${item.quantity}',
                              variant: TextVariant.bodyMedium,
                              tone: TextTone.primary,
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onTap: () => cubit.incrementQuantity(item.id),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      '${item.total.toStringAsFixed(0)} \u062c.\u0645',
                      variant: TextVariant.bodyMedium,
                      tone: TextTone.neonBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => cubit.removeItem(item.id),
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDesignChip extends StatelessWidget {
  const _CustomDesignChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: .35)),
      ),
      child: const CustomText(
        '\u062a\u0635\u0645\u064a\u0645 \u0645\u062e\u0635\u0635',
        variant: TextVariant.labelSmall,
        tone: TextTone.neonBlue,
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
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.darkTextPrimary, size: 16),
        ),
      ),
    );
  }
}
