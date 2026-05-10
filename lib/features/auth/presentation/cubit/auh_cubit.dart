import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void toggleMode() {
    emit(state.copyWith(isRegister: !state.isRegister));
  }

  void togglePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
  }
}
