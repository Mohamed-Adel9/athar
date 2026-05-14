import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/custom_text.dart';

import '../../../../../shared/widgets/glass_card.dart';
import '../../../data/models/payment_method.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';
import 'checkout_appbar.dart';

class PaymentStep extends StatelessWidget {
  const PaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final state = context.watch<CartCubit>().state;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: CheckoutAppBar(title: 'طريقة الدفع')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Payment Methods
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'طريقة الدفع',
                        variant: TextVariant.titleMedium,
                        tone: TextTone.primary,
                      ),
                      const SizedBox(height: 16),
                      _PaymentOption(
                        title: 'الدفع عند الاستلام',
                        subtitle: 'ادفع نقداً عند استلام الطلب',
                        icon: Icons.money,
                        isSelected: state.paymentMethod == PaymentMethod.cashOnDelivery,
                        onTap: () => cubit.selectPaymentMethod(PaymentMethod.cashOnDelivery),
                      ),
                      const SizedBox(height: 12),
                      _PaymentOption(
                        title: 'بطاقة الائتمان',
                        subtitle: 'Visa, Mastercard, أو American Express',
                        icon: Icons.credit_card,
                        isSelected: state.paymentMethod == PaymentMethod.creditCard,
                        onTap: () => cubit.selectPaymentMethod(PaymentMethod.creditCard),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order Summary
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'ملخص الطلب',
                        variant: TextVariant.titleMedium,
                        tone: TextTone.primary,
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow('المجموع الفرعي', '${state.subtotal.toStringAsFixed(0)} ج.م'),
                      const SizedBox(height: 8),
                      _SummaryRow('الشحن', '${state.deliveryFee.toStringAsFixed(0)} ج.م'),
                      if (state.discount > 0) ...[
                        const SizedBox(height: 8),
                        _SummaryRow('الخصم', '-${state.discount.toStringAsFixed(0)} ج.م', isDiscount: true),
                      ],
                      const Divider(height: 24, color: AppColors.darkBorder),
                      _SummaryRow('الإجمالي', '${state.total.toStringAsFixed(0)} ج.م', isTotal: true),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'إتمام الطلب',
                        onPressed: state.status != CartStatus.loading
                            ? () => cubit.placeOrder()
                            : null,
                      ),
                      if (state.status == CartStatus.loading)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.neonBlue : AppColors.darkBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.neonBlue.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.neonBlue.withValues(alpha: 0.15)
                    : AppColors.darkSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.neonBlue : AppColors.darkTextSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    variant: TextVariant.bodyMedium,
                    tone: TextTone.primary,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    subtitle,
                    variant: TextVariant.labelSmall,
                    tone: TextTone.secondary,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.neonBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.isTotal = false, this.isDiscount = false});

  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

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
          tone: isTotal
              ? TextTone.neonBlue
              : isDiscount
              ? TextTone.success
              : TextTone.primary,
        ),
      ],
    );
  }
}