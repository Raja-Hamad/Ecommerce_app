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
  AppUser? get currentUser;
}
