import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/token_storage.dart';
import '../../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final _client = ApiClient.instance;

  /// Authenticates and persists the returned token. The login endpoint only
  /// returns a JWT, not the profile, so callers should follow up with
  /// [getProfile] to hydrate the full user.
  Future<void> login({required String email, required String password}) async {
    final response = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    final token = response['token'] as String;
    await TokenStorage.instance.saveToken(token);
  }

  Future<AppUser> getProfile() async {
    final response = await _client.get(ApiEndpoints.profile);
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String role,
    File? profileImage,
  }) async {
    final response = await _client.multipart(
      ApiEndpoints.register,
      fields: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
      files: profileImage != null ? {'profileImage': profileImage} : const {},
    );
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }
}
