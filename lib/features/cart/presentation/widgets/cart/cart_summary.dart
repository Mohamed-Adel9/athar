import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_input.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Promo Code
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        hintText: 'أدخل الكود',
                        controller: TextEditingController(
                          text: state.promoCode,
                        ),
                        suffixIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.neonBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_offer_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'ملخص الطلب',
                      variant: TextVariant.titleMedium,
                      tone: TextTone.primary,
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'المجموع الفرعي',
                      value: '${state.subtotal.toStringAsFixed(0)} ج.م',
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'الشحن',
                      value: '${state.deliveryFee.toStringAsFixed(0)} ج.م',
                    ),
                    if (state.discount > 0) ...[
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'الخصم',
                        value: '-${state.discount.toStringAsFixed(0)} ج.م',
                        valueColor: AppColors.success,
                      ),
                    ],
                    const Divider(height: 24, color: AppColors.darkBorder),
                    _SummaryRow(
                      label: 'الإجمالي',
                      value: '${state.total.toStringAsFixed(0)} ج.م',
                      isTotal: true,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      text: 'إتمام الشراء',
                      isFullWidth: true,
                      onPressed: state.canProceedToShipping
                          ? () {
                              context.go('/checkout');
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          variant: isTotal ? TextVariant.titleMedium : TextVariant.bodyMedium,
          tone: isTotal ? TextTone.primary : TextTone.secondary,
        ),
        CustomText(
          value,
          variant: isTotal ? TextVariant.titleMedium : TextVariant.bodyMedium,
          tone: isTotal ? TextTone.neonBlue : TextTone.primary,
        ),
      ],
    );
  }
}
