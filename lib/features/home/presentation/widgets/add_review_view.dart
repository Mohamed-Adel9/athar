import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../cubit/home_cubit.dart';

class AddReviewView extends StatefulWidget {
  const AddReviewView({super.key});

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      SnackBarService.failure(
        context: context,
        message: 'اكتب اسمك ورأيك أولا',
      );
      return;
    }

    context.read<HomeCubit>().addReview(
      name: name,
      text: review,
      rating: _rating,
    );

    SnackBarService.success(
      context: context,
      message: 'شكرا لك، تمت إضافة رأيك',
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.darkTextPrimary),
        ),
        title: const CustomText('أضف رأيك', variant: TextVariant.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'شارك تجربتك مع أثر',
                    variant: TextVariant.headingSmall,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  CustomText(
                    'رأيك يساعد زوار المتجر يعرفوا جودة المنتجات والتجربة قبل الطلب.',
                    variant: TextVariant.bodyMedium,
                    tone: TextTone.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText('التقييم', variant: TextVariant.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: List.generate(5, (index) {
                      final value = index + 1;
                      return IconButton(
                        onPressed: () => setState(() => _rating = value),
                        icon: Icon(
                          value <= _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ReviewField(
                    controller: _nameController,
                    hintText: 'اسمك',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ReviewField(
                    controller: _reviewController,
                    hintText: 'اكتب رأيك هنا...',
                    prefixIcon: Icons.rate_review_outlined,
                    maxLines: 5,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'إرسال الرأي',
                    icon: const Icon(Icons.send_outlined, color: Colors.white),
                    onPressed: _submit,
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

class _ReviewField extends StatelessWidget {
  const _ReviewField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: .7)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.darkTextPrimary),
        cursorColor: AppColors.neonBlue,
        decoration: InputDecoration(
          icon: Icon(prefixIcon, color: AppColors.darkTextSecondary),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
        ),
      ),
    );
  }
}
