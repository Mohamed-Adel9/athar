import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../home/presentation/cubit/home_cubit.dart';
import '../../../../home/presentation/widgets/bottom_nav/bottom_nav_tab.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                context.read<HomeCubit>().changeTab(BottomNavTab.shop);
              },
            ),
          ],
        ),
      ),
    );
  }
}
