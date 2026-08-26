import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/snack_bar_service.dart';
import '../../../../../shared/theme/app_color.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_input.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final TextEditingController _promoCodeController = TextEditingController();

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode() async {
    final code = _promoCodeController.text.trim();

    if (code.isEmpty) {
      SnackBarService.failure(
        context: context,
        message: 'Enter a promo code first',
      );
      return;
    }

    final cubit = context.read<CartCubit>();
    final applied = await cubit.applyPromoCode(code);
    if (!mounted) return;

    if (applied) {
      SnackBarService.success(context: context, message: 'Promo code applied');
    } else {
      SnackBarService.failure(
        context: context,
        message: cubit.state.errorMessage ?? 'Invalid promo code',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.promoCode.isNotEmpty &&
            _promoCodeController.text != state.promoCode) {
          _promoCodeController.text = state.promoCode;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        hintText: 'ادخل الكود',
                        controller: _promoCodeController,
                        suffixIcon: Tooltip(
                          message: 'Apply promo code',
                          child: InkWell(
                            onTap: _applyPromoCode,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(20),
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
                        tone: TextTone.success,
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
                              context.push('/checkout');
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
    this.isTotal = false,
    this.tone,
  });

  final String label;
  final String value;
  final bool isTotal;
  final TextTone? tone;

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
          tone: isTotal ? TextTone.neonBlue : (tone ?? TextTone.primary),
        ),
      ],
    );
  }
}
