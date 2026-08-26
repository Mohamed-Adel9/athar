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
                  color: selected
                      ? AppColors.neonBlue.withValues(alpha: .10)
                      : AppColors.surface(context),
                  border: Border.all(
                    color: selected
                        ? AppColors.neonBlue
                        : AppColors.border(context),
                    width: selected ? 1.6 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.neonBlue.withValues(alpha: .18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : AppShadows.soft,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(model.mockUpImage, fit: BoxFit.contain),
                      CustomText(
                        _displayTitle(model),
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

String _displayTitle(ProductTypeModel model) {
  switch (model.mockUpImage) {
    case 'assets/images/design/t-shirt.png':
      return 'تيشيرت';
    case 'assets/images/design/hoodie.png':
      return 'هودي';
    case 'assets/images/design/mug.png':
      return 'مج';
    case 'assets/images/design/tote-bag.png':
      return 'توتي باج';
    default:
      return model.title;
  }
}
