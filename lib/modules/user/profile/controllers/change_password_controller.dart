import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/auth_controller.dart';
import '../../../../core/utils/app_snackbar.dart';

class ChangePasswordController extends GetxController {
  final auth = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final RxBool obscureCurrent = true.obs;
  final RxBool obscureNew = true.obs;
  final RxBool obscureConfirm = true.obs;
  final RxBool isSaving = false.obs;

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
      final success = await auth.changePassword(
        currentPassword: currentPasswordCtrl.text,
        newPassword: newPasswordCtrl.text,
      );
      if (success) {
        // Navigate back to Profile first, then show the toast there —
        // Flushbar pushes itself as a route, so showing it before Get.back()
        // means back() closes the toast's own route instead of this screen.
        Get.back();
        AppSnackbar.success('Password changed successfully');
      }
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
