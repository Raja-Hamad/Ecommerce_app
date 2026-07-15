import 'dart:io';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser> login(String email, String password);
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    File? profileImage,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({required String token, required String newPassword});
  Future<AppUser> getProfile();
  Future<void> changePassword({required String currentPassword, required String newPassword});
  AppUser? get currentUser;
}
