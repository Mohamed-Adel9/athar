import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._loginUseCase,
    this._googleLoginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._restoreSessionUseCase,
  ) : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  void loginAsGuest() {
    emit(state.copyWith(isGuest: true, isAuthenticated: false));
  }

  Future<bool> restoreSession() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _restoreSessionUseCase();

    return result.fold(
      (failure) {
        _emitFailure(failure);
        return false;
      },
      (auth) {
        if (auth == null) {
          emit(const AuthState());
          return false;
        }

        emit(
          _authenticatedState(
            email: auth.email,
            id: auth.id,
            name: auth.name,
            role: auth.role,
          ),
        );
        return true;
      },
    );
  }

  Future<void> login(String email, String password) async {
    if (!_isValidLogin(email, password)) return;

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _loginUseCase(email: email.trim(), password: password);

    _emitAuthResult(
      result,
      onSuccess: (auth) => emit(
        _authenticatedState(
          email: auth.email ?? email.trim(),
          id: auth.id,
          name: auth.name,
          role: auth.role,
        ),
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    final result = await _googleLoginUseCase();

    _emitAuthResult(
      result,
      onSuccess: (auth) => emit(
        _authenticatedState(
          email: auth.email,
          id: auth.id,
          name: auth.name,
          role: auth.role,
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

    _emitAuthResult(
      result,
      onSuccess: (auth) => emit(
        _authenticatedState(
          email: auth.email ?? email.trim(),
          id: auth.id,
          name: auth.name ?? '${firstName.trim()} ${lastName.trim()}',
          role: auth.role,
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

  void _emitAuthResult(
    Result<AuthEntity> result, {
    required void Function(AuthEntity auth) onSuccess,
  }) {
    result.fold(_emitFailure, onSuccess);
  }

  void _emitFailure(Failure failure) {
    emit(
      state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  AuthState _authenticatedState({
    required String? email,
    required String? id,
    required String? name,
    required UserRole role,
  }) {
    return state.copyWith(
      status: AuthStatus.success,
      isAuthenticated: true,
      isGuest: false,
      userId: id ?? email,
      email: email,
      name: name,
      role: role,
      clearError: true,
    );
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
