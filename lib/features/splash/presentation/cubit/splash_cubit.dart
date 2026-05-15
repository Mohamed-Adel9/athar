import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with real SharedPreferences logic
    const bool isLoggedIn = false;
    const bool onboardingSeen = false;

    if (!onboardingSeen) {
      emit(SplashNavigateToOnboarding());
    } else if (isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
