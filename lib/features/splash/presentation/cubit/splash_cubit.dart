import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._storageService, this._authCubit) : super(SplashInitial());

  final SecureStorageService _storageService;
  final AuthCubit _authCubit;

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    final onboardingSeen = await _storageService.hasSeenOnboarding();

    if (!onboardingSeen) {
      emit(SplashNavigateToOnboarding());
      return;
    }

    final isLoggedIn = await _authCubit.restoreSession();
    if (isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
