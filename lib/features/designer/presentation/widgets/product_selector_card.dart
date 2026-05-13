import 'package:athar/shared/theme/app_shadows.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/theme/app_color.dart';
import '../../data/models/product_type_model.dart';

class ProductSelectorCard extends StatelessWidget {
  const ProductSelectorCard({
    super.key,
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final ProductTypeModel model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          AnimatedContainer(
                duration: 300.ms,
                width: 105,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.darkSurface.withValues(alpha: .3),
                  border: Border.all(
                    color: selected ? AppColors.neonBlue : AppColors.darkBorder,
                    width: 1,
                  ),
                  boxShadow: selected ? AppShadows.medium : [],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(model.mockUpImage, fit: BoxFit.contain),
                      CustomText(
                        model.title,
                        textAlign: TextAlign.center,
                        variant: TextVariant.labelLarge,
                        tone: selected ? TextTone.neonBlue : TextTone.primary,
                      ),
                    ],
                  ),
                ),
              )
              .animate(target: selected ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),
    );
  }
}
