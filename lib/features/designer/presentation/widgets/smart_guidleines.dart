import 'package:flutter/material.dart';

import '../../../../shared/theme/app_color.dart';

class SmartGuidelines extends StatelessWidget {
  const SmartGuidelines({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 1.5,
            color: AppColors.neonBlue.withOpacity(.4),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 1.5,
            color: AppColors.neonBlue.withOpacity(.4),
          ),
        ),
      ],
    );
  }
}
