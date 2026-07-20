import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../settings/presentation/manager/settings_cubit.dart';
import '../../data/repo/splash_repo.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRepo splashRepo;
  SplashCubit({required this.splashRepo}) : super(SplashInitialState());

  Future<void> autoLogin() async {
    emit(SplashLoading());
    var data = await splashRepo.login();
    data.fold((failure) {
      if (sl<SettingsCubit>().state.isFirstTime) {
        emit(FirstTimeUser());
      } else {
        emit(SplashError(failure.message));
      }
    }, (success) => emit(SplashLoaded()));
  }
}
