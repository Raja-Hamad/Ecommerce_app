import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/utils/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool linkSent = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final auth = Get.find<AuthController>();
      final success = await auth.forgotPassword(emailCtrl.text.trim());
      if (success) {
        linkSent.value = true;
        AppSnackbar.success('Password reset link sent to your email');
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }
}
