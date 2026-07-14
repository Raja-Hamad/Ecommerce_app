import 'dart:io';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _ds = MockDataSource.instance;
  final _remote = AuthRemoteDataSource();

  @override
  AppUser? get currentUser => _ds.loggedInUser;

  @override
  Future<AppUser> login(String email, String password) async {
    final user = await _remote.login(email: email, password: password);
    _ds.loggedInUser = user;
    return user;
  }

  @override
  Future<AppUser> getProfile() async {
    final user = await _remote.getProfile();
    _ds.loggedInUser = user;
    return user;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    File? profileImage,
  }) async {
    final user = await _remote.register(
      name: name,
      email: email,
      password: password,
      role: role,
      profileImage: profileImage,
    );
    _ds.loggedInUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(_ds.latency);
    _ds.loggedInUser = null;
  }

  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) {
    return _remote.changePassword(currentPassword: currentPassword, newPassword: newPassword);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(_ds.latency);
  }
}
