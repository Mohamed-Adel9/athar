import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/custom_text.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: AppColors.darkTextSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          CustomText(
            'سلة التسوق فارغة',
            variant: TextVariant.titleMedium,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: 8),
          CustomText(
            'ابدأ التسوق واكتشف منتجاتنا المميزة',
            variant: TextVariant.bodySmall,
            tone: TextTone.muted,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'متابعة التسوق',
            isSecondary: true,
            onPressed: () {
              // TODO: Navigate to shop
            },
          ),
        ],
      ),
    );
  }
}