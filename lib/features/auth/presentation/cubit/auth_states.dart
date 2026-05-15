import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AuthState extends Equatable {
  final bool isRegister;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool isAuthenticated;
  final bool isGuest;
  final String? email;
  final String? name;
  final VoidCallback? pendingAction;
  final bool showAuthPrompt;

  const AuthState({
    this.isRegister = false,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.email,
    this.name,
    this.pendingAction,
    this.showAuthPrompt = false,
  });

  AuthState copyWith({
    bool? isRegister,
    bool? obscurePassword,
    bool? obscureConfirm,
    bool? isAuthenticated,
    bool? isGuest,
    String? email,
    String? name,
    VoidCallback? pendingAction,
    bool? showAuthPrompt,
    bool clearPendingAction = false,
  }) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      email: email ?? this.email,
      name: name ?? this.name,
      pendingAction: clearPendingAction
          ? null
          : (pendingAction ?? this.pendingAction),
      showAuthPrompt: showAuthPrompt ?? this.showAuthPrompt,
    );
  }

  @override
  List<Object?> get props => [
    isRegister,
    obscurePassword,
    obscureConfirm,
    isAuthenticated,
    isGuest,
    email,
    name,
    pendingAction,
    showAuthPrompt,
  ];
}
