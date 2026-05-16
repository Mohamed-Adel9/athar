import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../cubit/home_cubit.dart';
import 'bottom_nav/bottom_nav_tab.dart';

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
          onPressed: () {
            context.read<HomeCubit>().changeTab(BottomNavTab.designer);
          },
          height: AppSpacing.xxl,
          isFullWidth: false,
        ),
        AppButton(
          text: "تصفح المنتجات",
          onPressed: () {
            context.read<HomeCubit>().changeTab(BottomNavTab.shop);
          },
          height: AppSpacing.xxl,
          isFullWidth: false,
          isSecondary: true,
        ),
      ],
    );
  }
}
