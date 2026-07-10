import 'package:get/get.dart';
import '../controllers/auth_form_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthFormController());
  }
}
