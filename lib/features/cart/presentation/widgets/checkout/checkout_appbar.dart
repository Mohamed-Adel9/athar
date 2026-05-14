import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../cubit/cart_cubit.dart';

class CheckoutAppBar extends StatelessWidget {
  const CheckoutAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              final cartCubit = context.read<CartCubit>();
              if (cartCubit.state.currentStep > 1) {
                cartCubit.goBack();
              } else {
                context.pop(); // Back to cart
              }
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.darkTextPrimary),
          ),
          const SizedBox(width: 8),
          CustomText(
            title,
            variant: TextVariant.headingMedium,
            tone: TextTone.primary,
          ),
        ],
      ),
    );
  }
}