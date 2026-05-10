import 'package:flutter/material.dart';

import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class StartDesign extends StatelessWidget {
  const StartDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppButton(
          text: "ابدأ التصميم الآن",
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {},
          height: AppSpacing.xxl,
          isFullWidth: false,
        ),
        AppButton(
          text: "تصفح المنتجات",
          onPressed: () {},
          height: AppSpacing.xxl,
          isFullWidth: false,
          isSecondary: true,
        ),
      ],
    );
  }
}
