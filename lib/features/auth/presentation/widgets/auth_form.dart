import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_states.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
          final isLoading = state.status == AuthStatus.loading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xl),
              _Logo(),
              SizedBox(height: AppSpacing.xl),
              CustomText(
                state.isRegister ? 'إنشاء حساب جديد' : 'مرحبا بعودتك',
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
              if (state.isRegister) ...[
                AppInput(
                  hintText: 'الاسم الأول',
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  hintText: 'اسم العائلة',
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                SizedBox(height: AppSpacing.md),
                AppInput(
                  hintText: 'رقم الهاتف',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                SizedBox(height: AppSpacing.md),
              ],
              AppInput(
                hintText: 'البريد الإلكتروني',
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
              if (state.isRegister) ...[
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
              SizedBox(height: AppSpacing.xl),
              AppButton(
                text: isLoading
                    ? 'جاري التحميل...'
                    : state.isRegister
                    ? 'إنشاء حساب'
                    : 'تسجيل الدخول',
                onPressed: isLoading ? null : () => _submit(context, state),
                isFullWidth: true,
              ),
              if (!state.isRegister) ...[
                SizedBox(height: AppSpacing.lg),
                _DividerLabel(),
                SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'المتابعة باستخدام Google',
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    size: 20,
                    color: Colors.white,
                  ),
                  isSecondary: true,
                  isFullWidth: true,
                  onPressed: isLoading ? null : cubit.loginWithGoogle,
                ),
              ],
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
                              : 'إنشاء حساب',
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
        SnackBarService.failure(
          context: context,
          message: 'كلمتا المرور غير متطابقتين',
        );
        return;
      }

      cubit.register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      return;
    }

    cubit.login(_emailController.text, _passwordController.text);
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xl * 2,
      height: AppSpacing.xl * 2,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Center(
        child: Image.asset('assets/app_icons/splash/logo.png'),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.darkBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: CustomText(
            'أو',
            variant: TextVariant.labelMedium,
            tone: TextTone.secondary,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.darkBorder)),
      ],
    );
  }
}
