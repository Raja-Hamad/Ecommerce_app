import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _ds = MockDataSource.instance;

  @override
  AppUser? get currentUser => _ds.loggedInUser;

  @override
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(_ds.latency);
    final user = AppUser(id: 'u1', name: email.split('@').first, email: email, phone: '+1 555 123 4567');
    _ds.loggedInUser = user;
    return user;
  }

  @override
  Future<AppUser> register(String name, String email, String password) async {
    await Future.delayed(_ds.latency);
    final user = AppUser(id: 'u1', name: name, email: email);
    _ds.loggedInUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(_ds.latency);
    _ds.loggedInUser = null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(_ds.latency);
  }
}
