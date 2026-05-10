import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/widgets/app_button.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_shadows.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingViewBody extends StatelessWidget {
  final VoidCallback onComplete;

  const OnboardingViewBody({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: SafeArea(
            child: Column(
              children: [
                /// Skip
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: AppSpacing.lg),
                    child: TextButton(
                      onPressed: onComplete,
                      child: CustomText(
                        'تخطي',
                        variant: TextVariant.bodyMedium,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                /// PageView
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: cubit.pageController,
                    onPageChanged: cubit.onPageChanged,
                    itemCount: cubit.pages.length,
                    itemBuilder: (context, index) {
                      return _ArtworkCard(page: cubit.pages[index]);
                    },
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                /// Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    cubit.pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      width: state.currentPage == index
                          ? AppSpacing.lg
                          : AppSpacing.sm,
                      height: AppSpacing.sm,
                      decoration: BoxDecoration(
                        color: state.currentPage == index
                            ? AppColors.primary
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// Text
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: cubit.fadeController,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: cubit.slideController,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                            child: CustomText(
                              cubit.pages[state.currentPage]['title'],
                              textAlign: TextAlign.center,
                              variant: TextVariant.headingMedium,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        FadeTransition(
                          opacity: cubit.fadeController,
                          child: CustomText(
                            cubit.pages[state.currentPage]['subtitle'],
                            textAlign: TextAlign.center,
                            variant: TextVariant.captionMedium,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(onPressed: onComplete, text: 'ابدا الان'),
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

class _ArtworkCard extends StatelessWidget {
  final Map<String, dynamic> page;

  const _ArtworkCard({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth * .78;

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// Background Decorative Card
                Transform.translate(
                  offset: const Offset(AppSpacing.md, -AppSpacing.md),
                  child: SizedBox(
                    width: cardWidth,
                    child: AspectRatio(
                      aspectRatio: 0.74,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: AppShadows.strong,
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Main Card
                SizedBox(
                  width: cardWidth,
                  child: AspectRatio(
                    aspectRatio: 0.74,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.strong,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Image.asset(page['image'], fit: BoxFit.cover),
                      ),
                    ),
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
