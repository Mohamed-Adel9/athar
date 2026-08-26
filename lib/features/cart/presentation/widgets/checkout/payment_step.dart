import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/snack_bar_service.dart';
import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../../data/models/payment_method.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';
import 'checkout_appbar.dart';

const String _instapayPhone = '01116450688';
const String _instapayName = 'Athar Store';

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
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'طريقة الدفع',
                        variant: TextVariant.titleMedium,
                        tone: TextTone.primary,
                      ),
                      const SizedBox(height: 16),
                      _PaymentOption(
                        title: 'الدفع عند الاستلام',
                        subtitle: 'ادفع نقدا عند استلام الطلب',
                        icon: Icons.money,
                        isSelected:
                            state.paymentMethod == PaymentMethod.cashOnDelivery,
                        onTap: () => cubit.selectPaymentMethod(
                          PaymentMethod.cashOnDelivery,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PaymentOption(
                        title: 'InstaPay / فودافون كاش',
                        subtitle: 'حوّل على الرقم ثم أكمل الطلب',
                        icon: Icons.account_balance_wallet_outlined,
                        isSelected:
                            state.paymentMethod == PaymentMethod.instapay,
                        onTap: () =>
                            cubit.selectPaymentMethod(PaymentMethod.instapay),
                      ),
                      if (state.paymentMethod == PaymentMethod.instapay) ...[
                        const SizedBox(height: 12),
                        _InstapayDetails(amount: state.total),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'ملخص الطلب',
                        variant: TextVariant.titleMedium,
                        tone: TextTone.primary,
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        'المجموع الفرعي',
                        '${state.subtotal.toStringAsFixed(0)} ج.م',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        'الشحن',
                        '${state.deliveryFee.toStringAsFixed(0)} ج.م',
                      ),
                      if (state.discount > 0) ...[
                        const SizedBox(height: 8),
                        _SummaryRow(
                          'الخصم',
                          '-${state.discount.toStringAsFixed(0)} ج.م',
                          isDiscount: true,
                        ),
                      ],
                      Divider(height: 24, color: AppColors.border(context)),
                      _SummaryRow(
                        'الإجمالي',
                        '${state.total.toStringAsFixed(0)} ج.م',
                        isTotal: true,
                      ),
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

class _InstapayDetails extends StatelessWidget {
  const _InstapayDetails({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context).withValues(alpha: .72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: .45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'بيانات التحويل',
            variant: TextVariant.labelLarge,
            tone: TextTone.primary,
          ),
          const SizedBox(height: 8),
          const CustomText(
            'حوّل قيمة الطلب على InstaPay او فودافون كاش، ثم اضغط إتمام الطلب. سيتم تأكيد التحويل قبل تجهيز الطلب.',
            variant: TextVariant.bodySmall,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: 12),
          _TransferRow(label: 'الاسم', value: _instapayName),
          const SizedBox(height: 8),
          _TransferRow(
            label: 'رقم التحويل',
            value: _instapayPhone,
            canCopy: true,
          ),
          const SizedBox(height: 8),
          _TransferRow(
            label: 'المبلغ',
            value: '${amount.toStringAsFixed(0)} ج.م',
          ),
        ],
      ),
    );
  }
}

class _TransferRow extends StatelessWidget {
  const _TransferRow({
    required this.label,
    required this.value,
    this.canCopy = false,
  });

  final String label;
  final String value;
  final bool canCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            label,
            variant: TextVariant.labelSmall,
            tone: TextTone.secondary,
          ),
        ),
        Flexible(
          flex: 2,
          child: CustomText(
            value,
            variant: TextVariant.labelMedium,
            tone: TextTone.primary,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (canCopy) ...[
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (!context.mounted) return;
              SnackBarService.success(
                context: context,
                message: 'تم نسخ رقم التحويل',
              );
            },
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.neonBlue.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.copy,
                color: AppColors.neonBlue,
                size: 18,
              ),
            ),
          ),
        ],
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
            color: isSelected ? AppColors.neonBlue : AppColors.border(context),
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
                    : AppColors.surfaceVariant(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.neonBlue
                    : AppColors.textSecondary(context),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
  const _SummaryRow(
    this.label,
    this.value, {
    this.isTotal = false,
    this.isDiscount = false,
  });

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
