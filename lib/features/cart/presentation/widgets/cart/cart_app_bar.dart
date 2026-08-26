import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../home/presentation/cubit/home_cubit.dart';
import '../../../../home/presentation/widgets/bottom_nav/bottom_nav_tab.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
                return;
              }

              context.read<HomeCubit>().changeTab(BottomNavTab.shop);
              context.go('/home');
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 8),
          CustomText(
            'سلة التسوق',
            variant: TextVariant.headingMedium,
            tone: TextTone.primary,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocSelector<CartCubit, CartState, int>(
              selector: (state) => state.itemCount,
              builder: (context, count) {
                return CustomText(
                  '($count منتجات)',
                  variant: TextVariant.labelMedium,
                  tone: TextTone.neonBlue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
