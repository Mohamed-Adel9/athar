import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_role.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final bool isRegister;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool isAuthenticated;
  final bool isGuest;
  final String? userId;
  final String? email;
  final String? name;
  final UserRole? role;
  final VoidCallback? pendingAction;
  final bool showAuthPrompt;
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.isRegister = false,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.userId,
    this.email,
    this.name,
    this.role,
    this.pendingAction,
    this.showAuthPrompt = false,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isRegister,
    bool? obscurePassword,
    bool? obscureConfirm,
    bool? isAuthenticated,
    bool? isGuest,
    String? userId,
    String? email,
    String? name,
    UserRole? role,
    VoidCallback? pendingAction,
    bool? showAuthPrompt,
    AuthStatus? status,
    String? errorMessage,
    bool clearPendingAction = false,
    bool clearError = false,
  }) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      pendingAction: clearPendingAction
          ? null
          : (pendingAction ?? this.pendingAction),
      showAuthPrompt: showAuthPrompt ?? this.showAuthPrompt,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isAdmin => isAuthenticated && role == UserRole.admin;
  bool get isUser => isAuthenticated && role == UserRole.user;

  @override
  List<Object?> get props => [
    isRegister,
    obscurePassword,
    obscureConfirm,
    isAuthenticated,
    isGuest,
    userId,
    email,
    name,
    role,
    pendingAction,
    showAuthPrompt,
    status,
    errorMessage,
  ];
}
