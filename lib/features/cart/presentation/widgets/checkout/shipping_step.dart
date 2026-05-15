import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/snack_bar_service.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_input.dart';
import '../../../../../shared/widgets/custom_text.dart';
import '../../../../../shared/widgets/glass_card.dart';
import '../../cubit/cart_cubit.dart';
import 'checkout_appbar.dart';

class ShippingStep extends StatefulWidget {
  const ShippingStep({super.key});

  @override
  State<ShippingStep> createState() => _ShippingStepState();
}

class _ShippingStepState extends State<ShippingStep> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _postalCodeCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<CartCubit>().state;
    _firstNameCtrl = TextEditingController(text: state.shippingInfo.firstName);
    _lastNameCtrl = TextEditingController(text: state.shippingInfo.lastName);
    _phoneCtrl = TextEditingController(text: state.shippingInfo.phone);
    _addressCtrl = TextEditingController(text: state.shippingInfo.address);
    _cityCtrl = TextEditingController(text: state.shippingInfo.city);
    _postalCodeCtrl = TextEditingController(
      text: state.shippingInfo.postalCode,
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

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
                    controller: _firstNameCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(firstName: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('اسم العائلة'),
                  AppInput(
                    hintText: 'محمد',
                    controller: _lastNameCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(lastName: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('رقم الهاتف'),
                  AppInput(
                    hintText: '+201234567890',
                    keyboardType: TextInputType.phone,
                    controller: _phoneCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(phone: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('العنوان'),
                  AppInput(
                    hintText: 'الشارع والحي',
                    controller: _addressCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(address: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('المدينة'),
                  AppInput(
                    hintText: 'القاهرة مثلاً',
                    controller: _cityCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(city: v),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('الرمز البريدي'),
                  AppInput(
                    hintText: '12345',
                    keyboardType: TextInputType.number,
                    controller: _postalCodeCtrl,
                    onChanged: (v) => cubit.updateShippingInfo(
                      cubit.state.shippingInfo.copyWith(postalCode: v),
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: 'متابعة',
                    onPressed: () {
                      if (cubit.state.canProceedToPayment) {
                        cubit.goToPayment();
                      } else {
                        SnackBarService.failure(
                          context: context,
                          message: 'يرجى إكمال جميع حقول الشحن',
                        );
                      }
                    },
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
