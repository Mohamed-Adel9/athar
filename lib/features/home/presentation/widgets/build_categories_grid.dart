import 'package:athar/shared/theme/app_color.dart';
import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/theme/app_shadows.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:athar/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../shared/theme/app_spacing.dart';
import '../../data/models/category_model.dart';
import '../cubit/home_cubit.dart';
import 'bottom_nav/bottom_nav_tab.dart';

Widget buildCategoriesGrid() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.99,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = [
          Category(id: "1", name: "تيشيرتات", icon: FontAwesomeIcons.shirt),
          Category(id: "2", name: "اكواب", icon: FontAwesomeIcons.mugHot),
          Category(id: "3", name: "هدايا", icon: FontAwesomeIcons.gift),
          Category(id: "4", name: "اطارات", icon: FontAwesomeIcons.hashtag),
        ];

        return GestureDetector(
          onTap: () {
            context.read<HomeCubit>().changeTab(BottomNavTab.shop);
          },
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: FaIcon(
                      category[index].icon,
                      size: 25,
                      shadows: AppShadows.strong,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                CustomText(category[index].name),
              ],
            ),
          ),
        );
      }, childCount: 4),
    ),
  );
}
