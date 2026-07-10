import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class ProfileController extends GetxController {
  final auth = Get.find<AuthController>();

  Future<void> logout() async {
    await auth.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
