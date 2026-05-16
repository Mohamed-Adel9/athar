import 'package:athar/features/home/presentation/cubit/home_cubit.dart';
import 'package:athar/features/home/presentation/widgets/bottom_nav/bottom_nav_tab.dart';
import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/theme/app_spacing.dart';
import 'package:athar/shared/widgets/app_button.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:athar/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key, re});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              "خصومات وعروض!",
              variant: TextVariant.labelMedium,
              tone: TextTone.neonBlue,
            ),
            CustomText(
              "خصومات تصل إلي 50%",
              variant: TextVariant.headingSmall,
              tone: TextTone.primary,
            ),
            CustomText(
              "على مجموعة مختارة من الملابس المخصصة",
              variant: TextVariant.bodySmall,
              tone: TextTone.primary,
            ),
            AppButton(
              text: "تسوق ألان",
              isSecondary: true,
              height: AppSpacing.xxl,
              onPressed: () {
                context.read<HomeCubit>().changeTab(BottomNavTab.shop);
              },
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
