import 'user_role.dart';

class AuthEntity {
  final String? id;
  final String? name;
  final String token;
  final String? email;
  final String? phone;
  final UserRole role;

  const AuthEntity({
    required this.token,
    this.role = UserRole.user,
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  bool get isAdmin => role.isAdmin;
  bool get isUser => role.isUser;
}
