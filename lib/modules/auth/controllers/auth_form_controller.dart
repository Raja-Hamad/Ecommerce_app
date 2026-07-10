import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';

class AuthFormController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final loginEmailCtrl = TextEditingController(text: 'demo@shopyfy.com');
  final loginPasswordCtrl = TextEditingController(text: '123456');

  final nameCtrl = TextEditingController();
  final registerEmailCtrl = TextEditingController();
  final registerPasswordCtrl = TextEditingController();

  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;

  Future<void> submitLogin() async {
    if (!loginFormKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final success = await auth.login(loginEmailCtrl.text.trim(), loginPasswordCtrl.text);
    if (success) {
      AppSnackbar.success('Welcome back!');
      Get.offAllNamed(AppRoutes.root);
    }
  }

  Future<void> submitRegister() async {
    if (!registerFormKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final success = await auth.register(nameCtrl.text.trim(), registerEmailCtrl.text.trim(), registerPasswordCtrl.text);
    if (success) {
      AppSnackbar.success('Account created successfully');
      Get.offAllNamed(AppRoutes.root);
    }
  }

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    nameCtrl.dispose();
    registerEmailCtrl.dispose();
    registerPasswordCtrl.dispose();
    super.onClose();
  }
}
