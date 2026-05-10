import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          onComplete: () {
            context.go('/login');
          },
        ),
      ),
    );
  }
}
