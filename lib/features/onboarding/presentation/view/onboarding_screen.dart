import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_view_body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: OnboardingViewBody(
          onComplete: () async {
            await sl<SecureStorageService>().markOnboardingSeen();
            if (!context.mounted) return;
            context.go('/login');
          },
          onSkip: () async {
            await sl<SecureStorageService>().markOnboardingSeen();
            if (!context.mounted) return;
            // Sign in as guest and go to home
            context.read<AuthCubit>().loginAsGuest();
            context.go('/home');
          },
        ),
      ),
    );
  }
}
