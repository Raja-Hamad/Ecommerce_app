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
    await Future.delayed(const Duration(milliseconds: 1800));
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn) {
      Get.offAllNamed(AppRoutes.root);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
