enum UserRole {
  admin,
  user;

  bool get isAdmin => this == UserRole.admin;
  bool get isUser => this == UserRole.user;

  String get storageValue {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.user:
        return 'user';
    }
  }

  static UserRole fromValue(Object? value) {
    if (value is bool) return value ? UserRole.admin : UserRole.user;

    final normalized = value?.toString().trim().toLowerCase();
    switch (normalized) {
      case 'admin':
      case 'administrator':
      case 'super_admin':
      case 'superadmin':
      case '1':
      case 'true':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }
}
