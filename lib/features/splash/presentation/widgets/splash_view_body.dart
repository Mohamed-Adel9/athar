import 'package:athar/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      child: Center(child: Image.asset("assets/app_icons/splash/logo.png")),
    );
  }
}
