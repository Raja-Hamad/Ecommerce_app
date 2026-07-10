import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) => _show('Success', message, AppColors.success, Icons.check_circle_rounded);

  static void error(String message) => _show('Oops', message, AppColors.error, Icons.error_rounded);

  static void info(String message) => _show('Info', message, AppColors.primary, Icons.info_rounded);

  static void _show(String title, String message, Color color, IconData icon) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
