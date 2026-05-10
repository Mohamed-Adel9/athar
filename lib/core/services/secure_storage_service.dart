import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  String? _cachedToken;

  SecureStorageService(this._storage);

  String? get cachedToken => _cachedToken;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;

    _cachedToken = await _storage.read(key: 'auth_token');
    return _cachedToken;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    _cachedToken = token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
    _cachedToken = null;
  }
}
