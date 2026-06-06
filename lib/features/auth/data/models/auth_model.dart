import '../../domin/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.token,
    super.id,
    super.name,
    super.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return AuthModel(
      token: _readToken(json),
      id: user['id']?.toString(),
      name: user['name']?.toString(),
      email: user['email']?.toString(),
    );
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
