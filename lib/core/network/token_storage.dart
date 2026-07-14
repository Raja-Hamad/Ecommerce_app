import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();

  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_role';

  String? _cachedToken;
  String? _cachedRole;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<void> saveRole(String role) async {
    _cachedRole = role;
    await _storage.write(key: _roleKey, value: role);
  }

  Future<String?> readRole() async {
    if (_cachedRole != null) return _cachedRole;
    _cachedRole = await _storage.read(key: _roleKey);
    return _cachedRole;
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    _cachedRole = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _roleKey);
  }
}
