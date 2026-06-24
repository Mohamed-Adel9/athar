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
          role: auth.role,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (!_isValidRegister(firstName, lastName, email, phone, password)) return;

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _registerUseCase(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
      passwordConfirmation: passwordConfirmation,
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
          name: auth.name ?? '${firstName.trim()} ${lastName.trim()}',
          email: auth.email ?? email.trim(),
          role: auth.role,
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

  void requireAdmin(VoidCallback onAdmin) {
    if (state.isAdmin) {
      onAdmin();
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'This action requires an admin account.',
        ),
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

  bool _isValidRegister(
    String firstName,
    String lastName,
    String email,
    String phone,
    String password,
  ) {
    if (firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        email.trim().isEmpty ||
        phone.trim().isEmpty ||
        password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage:
              'Please enter first name, last name, email, phone and password.',
        ),
      );
      return false;
    }
    return true;
  }
}
