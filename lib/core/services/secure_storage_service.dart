import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/entities/user_role.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  static const String _onboardingSeenKey = 'onboarding_seen';
  String? _cachedToken;
  UserRole? _cachedRole;
  bool? _cachedOnboardingSeen;

  SecureStorageService(this._storage);

  String? get cachedToken => _cachedToken;
  UserRole? get cachedRole => _cachedRole;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;

    _cachedToken = await _storage.read(key: 'auth_token');
    return _cachedToken;
  }

  Future<UserRole?> getRole() async {
    if (_cachedRole != null) return _cachedRole;

    final value = await _storage.read(key: 'user_role');
    if (value == null || value.isEmpty) return null;

    _cachedRole = UserRole.fromValue(value);
    return _cachedRole;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    _cachedToken = token;
  }

  Future<void> saveRole(UserRole role) async {
    await _storage.write(key: 'user_role', value: role.storageValue);
    _cachedRole = role;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
    _cachedToken = null;
  }

  Future<void> deleteRole() async {
    await _storage.delete(key: 'user_role');
    _cachedRole = null;
  }

  Future<void> clearAuth() async {
    await deleteToken();
    await deleteRole();
  }

  Future<bool> hasSeenOnboarding() async {
    if (_cachedOnboardingSeen != null) return _cachedOnboardingSeen!;

    _cachedOnboardingSeen =
        await _storage.read(key: _onboardingSeenKey) == 'true';
    return _cachedOnboardingSeen!;
  }

  Future<void> markOnboardingSeen() async {
    await _storage.write(key: _onboardingSeenKey, value: 'true');
    _cachedOnboardingSeen = true;
  }
}
