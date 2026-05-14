import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_input.dart';
import '../../../../../shared/widgets/custom_text.dart';

import '../../../../../shared/widgets/glass_card.dart';
import '../../cubit/cart_cubit.dart';
import 'checkout_appbar.dart';

class ShippingStep extends StatelessWidget {
  const ShippingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final state = context.watch<CartCubit>().state;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: CheckoutAppBar(title: 'معلومات الشحن')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('الاسم الأول'),
                  AppInput(
                    hintText: 'أحمد',
                    controller: TextEditingController(text: state.shippingInfo.firstName),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(firstName: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('اسم العائلة'),
                  AppInput(
                    hintText: 'محمد',
                    controller: TextEditingController(text: state.shippingInfo.lastName),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(lastName: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('رقم الهاتف'),
                  AppInput(
                    hintText: '+20 1234567890',
                    keyboardType: TextInputType.phone,
                    controller: TextEditingController(text: state.shippingInfo.phone),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(phone: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('العنوان'),
                  AppInput(
                    hintText: 'الشارع والحي',
                    controller: TextEditingController(text: state.shippingInfo.address),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(address: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('المدينة'),
                  AppInput(
                    hintText: 'القاهرة مثلاً',
                    controller: TextEditingController(text: state.shippingInfo.city),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(city: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('الرمز البريدي'),
                  AppInput(
                    hintText: '12345',
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: state.shippingInfo.postalCode),
                    onChanged: (v) => cubit.updateShippingInfo(
                      state.shippingInfo.copyWith(postalCode: v),
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: 'متابعة',
                    onPressed: state.canProceedToPayment
                        ? () => cubit.goToPayment()
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomText(
        title,
        variant: TextVariant.labelMedium,
        tone: TextTone.secondary,
      ),
    );
  }
}