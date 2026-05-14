import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../cubit/cart_cubit.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            CustomText(
              'تم الطلب بنجاح!',
              variant: TextVariant.headingMedium,
              tone: TextTone.primary,
            ),
            const SizedBox(height: 8),
            CustomText(
              'سيتم شحن طلبك خلال 2-3 أيام عمل',
              variant: TextVariant.bodyMedium,
              tone: TextTone.secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'تتبع الطلب',
              onPressed: () {
                // TODO: Navigate to order tracking
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'متابعة التسوق',
              isSecondary: true,
              onPressed: () {
                context.read<CartCubit>().reset();
                // TODO: Navigate to shop
              },
            ),
          ],
        ),
      ),
    );
  }
}