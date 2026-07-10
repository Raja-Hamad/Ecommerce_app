import 'package:get/get.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

class AuthController extends GetxController {
  final _repo = AuthRepositoryImpl();

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => user.value != null;

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      user.value = await _repo.login(email, password);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading.value = true;
    try {
      user.value = await _repo.register(name, email, password);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    user.value = null;
  }

  void updateProfile({String? name, String? phone}) {
    if (user.value == null) return;
    user.value = user.value!.copyWith(name: name, phone: phone);
  }
}
