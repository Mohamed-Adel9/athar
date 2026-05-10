import 'package:athar/shared/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/auh_cubit.dart';
import '../cubit/auth_states.dart';

class AuthViewBody extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const AuthViewBody({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

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

              // 🔥 Logo
              Container(
                width: AppSpacing.xl * 2,
                height: AppSpacing.xl * 2,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Center(
                  child: Image.asset("assets/app_icons/splash/logo.png"),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // 🧠 Title
              CustomText(
                state.isRegister ? "إنشاء حساب جديد" : "مرحباً بعودتك",
                variant: TextVariant.headingMedium,
              ),

              SizedBox(height: AppSpacing.sm),

              CustomText(
                state.isRegister
                    ? "ابدأ رحلتك في تصميم أثر"
                    : "سجل دخولك للمتابعة",
                variant: TextVariant.labelMedium,
                tone: TextTone.secondary,
              ),

              SizedBox(height: AppSpacing.xl),

              // 📧 Email
              AppInput(
                hintText: 'البريد الإلكتروني',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),

              SizedBox(height: AppSpacing.md),

              // 🔒 Password
              AppInput(
                hintText: 'كلمة المرور',
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

              // 🔒 Confirm Password
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    AppInput(
                      hintText: 'تأكيد كلمة المرور',
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

              // 🔘 Button
              AppButton(
                text: state.isRegister ? "إنشاء حساب" : "تسجيل الدخول",
                onPressed: state.isRegister ? onRegister : onLogin,
                isFullWidth: true,
              ),

              SizedBox(height: AppSpacing.xl),

              // 🔁 Toggle
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
                              ? "لديك حساب بالفعل؟ "
                              : "ليس لديك حساب؟ ",
                        ),

                        TextSpan(
                          text: state.isRegister
                              ? "تسجيل الدخول"
                              : "إنشاء حساب",

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
}
