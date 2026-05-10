import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isRegister;
  final bool obscurePassword;
  final bool obscureConfirm;

  const AuthState({
    this.isRegister = false,
    this.obscurePassword = true,
    this.obscureConfirm = true,
  });

  AuthState copyWith({
    bool? isRegister,
    bool? obscurePassword,
    bool? obscureConfirm,
  }) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }

  @override
  List<Object?> get props => [isRegister, obscurePassword, obscureConfirm];
}
