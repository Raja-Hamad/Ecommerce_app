import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/controllers/auth_controller.dart';
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
  final Rxn<File> profileImage = Rxn<File>();

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);
    if (picked != null) profileImage.value = File(picked.path);
  }

  Future<void> submitLogin() async {
    if (!loginFormKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final success = await auth.login(loginEmailCtrl.text.trim(), loginPasswordCtrl.text);
    if (success) {
      AppSnackbar.success('Welcome back!');
      Get.offAllNamed(auth.homeRoute);
    }
  }

  Future<void> submitRegister() async {
    if (!registerFormKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final success = await auth.register(
      name: nameCtrl.text.trim(),
      email: registerEmailCtrl.text.trim(),
      password: registerPasswordCtrl.text,
      role: 'user',
      profileImage: profileImage.value,
    );
    if (success) {
      AppSnackbar.success('Account created successfully');
      Get.offAllNamed(auth.homeRoute);
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
