import '../../domin/entities/auth_entity.dart';
import '../../domin/entities/user_role.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.token,
    super.role,
    super.id,
    super.name,
    super.email,
    super.phone,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return AuthModel(
      token: _readToken(json),
      id: user['id']?.toString(),
      name: _readName(user),
      email: user['email']?.toString(),
      phone: user['phone']?.toString(),
      role: _readRole(json, user),
    );
  }

  static String? _readName(Map<String, dynamic> user) {
    final name = user['name']?.toString();
    if (name != null && name.isNotEmpty) return name;

    final firstName = user['first_name']?.toString();
    final lastName = user['last_name']?.toString();
    final fullName = [
      firstName,
      lastName,
    ].where((part) => part != null && part.isNotEmpty).join(' ');

    return fullName.isEmpty ? null : fullName;
  }

  static UserRole _readRole(
    Map<String, dynamic> json,
    Map<String, dynamic> user,
  ) {
    final role =
        user['role'] ??
        user['user_role'] ??
        user['type'] ??
        user['user_type'] ??
        json['role'] ??
        json['user_role'] ??
        json['type'] ??
        json['user_type'] ??
        user['is_admin'] ??
        user['isAdmin'] ??
        json['is_admin'] ??
        json['isAdmin'];

    final data = json['data'];
    if (role == null && data is Map<String, dynamic>) {
      return UserRole.fromValue(
        data['role'] ??
            data['user_role'] ??
            data['type'] ??
            data['user_type'] ??
            data['is_admin'] ??
            data['isAdmin'],
      );
    }

    return UserRole.fromValue(role);
  }

  static String _readToken(Map<String, dynamic> json) {
    final token = json['token'] ?? json['access_token'] ?? json['auth_token'];
    if (token is String && token.isNotEmpty) return token;

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final nestedToken =
          data['token'] ?? data['access_token'] ?? data['auth_token'];
      if (nestedToken is String && nestedToken.isNotEmpty) return nestedToken;
    }

    throw const FormatException('Auth token was not found in the response.');
  }
}
