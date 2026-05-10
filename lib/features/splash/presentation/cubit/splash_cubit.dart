import 'dart:async';

import 'package:athar/features/splash/presentation/cubit/splash_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    /// TODO:
    /// Replace with real logic:
    ///
    /// - check token
    /// - check onboarding
    /// - check auth state

    final bool isLoggedIn = false;
    final bool onboardingSeen = false;

    if (!onboardingSeen) {
      emit(SplashNavigateToOnboarding());
    } else if (isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
