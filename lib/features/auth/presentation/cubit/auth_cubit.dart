import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void loginAsGuest() {
    emit(state.copyWith(isGuest: true, isAuthenticated: false));
  }

  void login(String email, String password) {
    // TODO: Replace with real API call
    emit(state.copyWith(isAuthenticated: true, isGuest: false, email: email));
  }

  void register(String name, String email, String password) {
    // TODO: Replace with real API call
    emit(
      state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        name: name,
        email: email,
      ),
    );
  }

  void logout() {
    emit(const AuthState());
  }

  void requireAuth(VoidCallback onAuthenticated) {
    if (state.isAuthenticated) {
      onAuthenticated();
    } else {
      emit(
        state.copyWith(pendingAction: onAuthenticated, showAuthPrompt: true),
      );
    }
  }

  void clearPendingAction() {
    emit(state.copyWith(pendingAction: null, showAuthPrompt: false));
  }

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
