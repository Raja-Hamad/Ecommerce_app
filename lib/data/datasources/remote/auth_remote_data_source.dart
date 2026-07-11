import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/jwt_decoder.dart';
import '../../../core/network/token_storage.dart';
import '../../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final _client = ApiClient.instance;

  Future<AppUser> login({required String email, required String password}) async {
    final response = await _client.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    final token = response['token'] as String;
    await TokenStorage.instance.saveToken(token);

    // Login only returns a JWT (userId + role), not the full profile,
    // so we decode the token and fall back to the email used to sign in.
    final claims = JwtDecoder.payload(token);
    return AppUser(
      id: claims['userId']?.toString() ?? '',
      name: '',
      email: email,
      role: claims['role'] as String? ?? 'user',
    );
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
