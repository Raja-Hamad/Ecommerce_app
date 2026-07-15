import 'dart:io';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/token_storage.dart';
import '../../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final _client = ApiClient.instance;

  /// Authenticates and persists the returned token + role. The login
  /// response now includes the full user profile, so no follow-up
  /// [getProfile] call is needed here.
  Future<AppUser> login({required String email, required String password}) async {
    final response = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    final token = response['token'] as String;
    final user = AppUser.fromJson(response['user'] as Map<String, dynamic>);
    await TokenStorage.instance.saveToken(token);
    await TokenStorage.instance.saveRole(user.role);
    return user;
  }

  Future<AppUser> getProfile() async {
    final response = await _client.get(ApiEndpoints.profile);
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _client.put(
      ApiEndpoints.changePassword,
      body: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<void> forgotPassword({required String email}) async {
    await _client.post(ApiEndpoints.forgotPassword, body: {'email': email});
  }

  Future<void> resetPassword({required String token, required String newPassword}) async {
    await _client.put(ApiEndpoints.resetPassword(token), body: {'newPassword': newPassword});
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
