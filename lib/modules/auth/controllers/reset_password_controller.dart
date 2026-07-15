import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final RxBool obscureNew = true.obs;
  final RxBool obscureConfirm = true.obs;
  final RxBool isSaving = false.obs;

  late final String token;

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments is String ? Get.arguments as String : '';
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'New password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your new password';
    if (value != newPasswordCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final auth = Get.find<AuthController>();
      final success = await auth.resetPassword(token: token, newPassword: newPasswordCtrl.text);
      if (success) {
        Get.offAllNamed(AppRoutes.login);
        AppSnackbar.success('Password reset successfully. Please sign in.');
      }
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
