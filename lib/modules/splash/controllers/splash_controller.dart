import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    final auth = Get.find<AuthController>();
    final results = await Future.wait([
      auth.tryAutoLogin(),
      Future.delayed(const Duration(milliseconds: 1800)),
    ]);
    final loggedIn = results[0] as bool;
    if (loggedIn) {
      Get.offAllNamed(AppRoutes.root);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
