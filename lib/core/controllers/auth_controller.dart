import 'dart:io';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../network/app_exception.dart';
import '../network/jwt_decoder.dart';
import '../network/token_storage.dart';
import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';

class AuthController extends GetxController {
  final _repo = AuthRepositoryImpl();

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => user.value != null;

  /// Where to land a logged-in user based on their role. Admin dashboard is
  /// still a placeholder until the admin APIs are ready.
  String get homeRoute => user.value?.role == 'user' ? AppRoutes.root : AppRoutes.adminDashboard;

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      user.value = await _repo.login(email, password);
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Login failed. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    File? profileImage,
  }) async {
    isLoading.value = true;
    try {
      user.value = await _repo.register(name: name, email: email, password: password, role: role, profileImage: profileImage);
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Registration failed. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Restores a session from a previously saved token (e.g. on app restart).
  Future<bool> tryAutoLogin() async {
    final token = await TokenStorage.instance.readToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      await TokenStorage.instance.clearToken();
      return false;
    }
    try {
      user.value = await _repo.getProfile();
      return true;
    } catch (_) {
      await TokenStorage.instance.clearToken();
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    await TokenStorage.instance.clearToken();
    user.value = null;
  }

  void updateProfile({String? name}) {
    if (user.value == null) return;
    user.value = user.value!.copyWith(name: name);
  }

  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await _repo.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to change password. Please try again.');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _repo.forgotPassword(email);
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to send reset link. Please try again.');
      return false;
    }
  }

  Future<bool> resetPassword({required String token, required String newPassword}) async {
    try {
      await _repo.resetPassword(token: token, newPassword: newPassword);
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to reset password. Please try again.');
      return false;
    }
  }
}
