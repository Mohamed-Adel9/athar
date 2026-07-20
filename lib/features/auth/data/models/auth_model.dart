import 'package:athar/features/auth/domain/entities/auth_entity.dart';

import '../../domain/entities/user_role.dart';

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

  factory AuthModel.fromResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Unexpected auth response format.');
    }

    final payload = data['data'];
    if (payload is Map<String, dynamic>) {
      return AuthModel.fromJson(payload);
    }

    return AuthModel.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.storageValue,
    };
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
        _readRoleValue(user) ??
        _readRoleValue(json);

    final data = json['data'];
    if (role == null && data is Map<String, dynamic>) {
      return UserRole.fromValue(_readRoleValue(data));
    }

    return UserRole.fromValue(role);
  }

  static Object? _readRoleValue(Map<String, dynamic> json) {
    final directRole =
        json['role'] ??
        json['user_role'] ??
        json['type'] ??
        json['user_type'] ??
        json['account_type'] ??
        json['is_admin'] ??
        json['isAdmin'] ??
        json['admin'];

    if (directRole != null) return directRole;

    final roleId = json['role_id'] ?? json['roleId'];
    if (roleId != null && roleId.toString() == '1') return UserRole.admin;

    final roles = json['roles'];
    if (roles is Iterable && roles.any(_isAdminRoleValue)) {
      return UserRole.admin;
    }

    final permissions = json['permissions'];
    if (permissions is Iterable && permissions.any(_isAdminRoleValue)) {
      return UserRole.admin;
    }

    return null;
  }

  static bool _isAdminRoleValue(Object? value) {
    if (value is Map<String, dynamic>) {
      return UserRole.fromValue(
            value['name'] ?? value['role'] ?? value['slug'] ?? value['title'],
          ) ==
          UserRole.admin;
    }

    return UserRole.fromValue(value) == UserRole.admin;
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
