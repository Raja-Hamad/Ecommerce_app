import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final _client = ApiClient.instance;

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
