import 'package:athar/features/home/presentation/widgets/athar_word.dart';
import 'package:athar/features/home/presentation/widgets/banner_section.dart';
import 'package:athar/features/home/presentation/widgets/bottom_nav/bottom_nav_tab.dart';
import 'package:athar/features/home/presentation/widgets/build_product_header.dart';
import 'package:athar/features/home/presentation/widgets/header_section.dart';
import 'package:athar/features/home/presentation/widgets/product_preview_section.dart';
import 'package:athar/features/home/presentation/widgets/start_design.dart';
import 'package:athar/shared/theme/app_spacing.dart';
import 'package:athar/shared/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

import 'build_categories_grid.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.onNavigate});

  final Function(BottomNavTab) onNavigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsGeometry.all(AppSpacing.lg),
                child: HeaderSection(onNavigate: onNavigate),
              ),
            ),
            SliverToBoxAdapter(child: CustomSearchBar(onChanged: (value) {})),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(child: BannerSection()),
            SliverToBoxAdapter(child: AtharWord()),
            SliverToBoxAdapter(child: StartDesign()),
            SliverToBoxAdapter(child: buildCategoriesHeader()),
            buildCategoriesGrid(),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: ProductPreviewSection()),
          ],
        ),
      ),
    );
  }
}
