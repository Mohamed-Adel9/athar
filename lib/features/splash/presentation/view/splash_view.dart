import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/splash_cubit.dart';
import '../cubit/splash_states.dart';
import '../widgets/splash_view_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplash(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnboarding) {
            context.go('/onboarding');
          }

          if (state is SplashNavigateToLogin) {
            context.go('/login');
          }

          if (state is SplashNavigateToHome) {
            context.go('/home');
          }
        },
        child: const Scaffold(body: SplashViewBody()),
      ),
    );
  }
}
