class AuthEntity {
  const AuthEntity({
    required this.token,
    this.id,
    this.name,
    this.email,
  });

  final String token;
  final String? id;
  final String? name;
  final String? email;
}
