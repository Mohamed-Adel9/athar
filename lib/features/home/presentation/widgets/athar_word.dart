import 'package:flutter/material.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';

class AtharWord extends StatelessWidget {
  const AtharWord({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText("أنت مبدع مع", variant: TextVariant.displaySmall),
          CustomText(
            " أثر",
            variant: TextVariant.displayLarge,
            tone: TextTone.neonBlue,
            gradient: AppColors.primaryGradient,
            fontFamily: 'Noto Nastaliq Urdu',
          ),
        ],
      ),
    );
  }
}
