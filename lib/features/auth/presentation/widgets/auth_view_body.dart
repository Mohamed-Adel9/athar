import 'package:athar/shared/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_states.dart';

class AuthViewBody extends StatefulWidget {
  const AuthViewBody({super.key});

  @override
  State<AuthViewBody> createState() => _AuthViewBodyState();
}

class _AuthViewBodyState extends State<AuthViewBody> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xl),
              Container(
                width: AppSpacing.xl * 2,
                height: AppSpacing.xl * 2,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Center(
                  child: Image.asset('assets/app_icons/splash/logo.png'),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              CustomText(
                state.isRegister ? 'انشاء حساب جديد' : 'مرحبا بعودتك',
                variant: TextVariant.headingMedium,
              ),
              SizedBox(height: AppSpacing.sm),
              CustomText(
                state.isRegister
                    ? 'ابدأ رحلتك في تصميم أثر'
                    : 'سجل دخولك للمتابعة',
                variant: TextVariant.labelMedium,
                tone: TextTone.secondary,
              ),
              SizedBox(height: AppSpacing.xl),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    AppInput(
                      hintText: 'الاسم',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],
                ),
                crossFadeState: state.isRegister
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              AppInput(
                hintText: 'البريد الالكتروني',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              SizedBox(height: AppSpacing.md),
              AppInput(
                hintText: 'كلمة المرور',
                controller: _passwordController,
                obscureText: state.obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: GestureDetector(
                  onTap: cubit.togglePassword,
                  child: Icon(
                    state.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    AppInput(
                      hintText: 'تأكيد كلمة المرور',
                      controller: _confirmPasswordController,
                      obscureText: state.obscureConfirm,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: cubit.toggleConfirmPassword,
                        child: Icon(
                          state.obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],
                ),
                crossFadeState: state.isRegister
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              SizedBox(height: AppSpacing.xl),
              AppButton(
                text: state.status == AuthStatus.loading
                    ? 'جاري التحميل...'
                    : state.isRegister
                    ? 'انشاء حساب'
                    : 'تسجيل الدخول',
                onPressed: state.status == AuthStatus.loading
                    ? null
                    : () => _submit(context, state),
                isFullWidth: true,
              ),
              SizedBox(height: AppSpacing.xl),
              Center(
                child: GestureDetector(
                  onTap: cubit.toggleMode,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: state.isRegister
                              ? 'لديك حساب بالفعل؟ '
                              : 'ليس لديك حساب؟ ',
                        ),
                        TextSpan(
                          text: state.isRegister
                              ? 'تسجيل الدخول'
                              : 'انشاء حساب',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submit(BuildContext context, AuthState state) {
    final cubit = context.read<AuthCubit>();

    if (state.isRegister) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
        );
        return;
      }

      cubit.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      return;
    }

    cubit.login(_emailController.text, _passwordController.text);
  }
}
