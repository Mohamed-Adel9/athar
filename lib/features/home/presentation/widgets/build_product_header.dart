import 'package:athar/shared/theme/app_spacing.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

Widget buildCategoriesHeader() {
  return Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText('التصنيفات', variant: TextVariant.headingLarge),
        SizedBox(height: 5),
        CustomText(
          'اختر الفئة التي تريد وابدأ التصميم',
          variant: TextVariant.bodySmall,
        ),
      ],
    ),
  );
}
