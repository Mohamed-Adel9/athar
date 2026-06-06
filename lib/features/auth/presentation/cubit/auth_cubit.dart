import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domin/usecases/login_usecase.dart';
import '../../domin/usecases/logout_usecase.dart';
import '../../domin/usecases/register_usecase.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase, this._registerUseCase, this._logoutUseCase)
    : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  void loginAsGuest() {
    emit(state.copyWith(isGuest: true, isAuthenticated: false));
  }

  Future<void> login(String email, String password) async {
    if (!_isValidLogin(email, password)) return;

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _loginUseCase(email: email.trim(), password: password);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (auth) => emit(
        state.copyWith(
          status: AuthStatus.success,
          isAuthenticated: true,
          isGuest: false,
          email: auth.email ?? email.trim(),
          name: auth.name,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> register(String name, String email, String password) async {
    if (!_isValidRegister(name, email, password)) return;

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _registerUseCase(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (auth) => emit(
        state.copyWith(
          status: AuthStatus.success,
          isAuthenticated: true,
          isGuest: false,
          name: auth.name ?? name.trim(),
          email: auth.email ?? email.trim(),
          clearError: true,
        ),
      ),
    );
  }

  Future<void> logout() async {
    await _logoutUseCase();
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

  bool _isValidLogin(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Please enter email and password.',
        ),
      );
      return false;
    }
    return true;
  }

  bool _isValidRegister(String name, String email, String password) {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Please enter name, email and password.',
        ),
      );
      return false;
    }
    return true;
  }
}
