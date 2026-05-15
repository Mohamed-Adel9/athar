import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/checkout/order_success.dart';
import '../widgets/checkout/payment_step.dart';
import '../widgets/checkout/shipping_step.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CartStatus.success) {
          // Show success then reset and go home
          Future.delayed(const Duration(seconds: 2), () {
            context.read<CartCubit>().reset();
            context.go('/home');
          });
        } else if (state.status == CartStatus.error &&
            state.errorMessage != null) {
          SnackBarService.failure(
            context: context,
            message: state.errorMessage!,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStep(state, context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(CartState state, BuildContext context) {
    switch (state.currentStep) {
      case 1:
        return const ShippingStep(key: ValueKey('shipping'));
      case 2:
        return const PaymentStep(key: ValueKey('payment'));
      case 3:
        return const OrderSuccess(key: ValueKey('success'));
      default:
        // If accessed directly, start at shipping
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CartCubit>().goToShipping();
        });
        return const SizedBox.shrink();
    }
  }
}
