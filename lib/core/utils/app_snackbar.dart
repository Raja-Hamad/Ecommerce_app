import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) => _show(message, AppColors.primaryDark, Icons.check_circle_rounded);

  static void error(String message) => _show(message, AppColors.error, Icons.error_rounded);

  static void info(String message) => _show(message, AppColors.primaryDark, Icons.info_rounded);

  static void _show(String message, Color color, IconData icon) {
    // Flushbar shows itself by pushing a route onto the Navigator. If a
    // caller also navigates (e.g. Get.back()) right after triggering a
    // snackbar, the two Navigator mutations can collide mid-transaction
    // ('!_debugLocked' assertion). Deferring to the next frame lets any
    // immediate navigation finish first, so the two never overlap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext ?? Get.context;
      if (context == null) return;
      Flushbar(
        messageText: Text(message, style: AppTextStyles.body.copyWith(color: Colors.white)),
        icon: Icon(icon, color: Colors.white),
        backgroundColor: color,
        margin: const EdgeInsets.all(AppSizes.md),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: const Duration(milliseconds: 300),
      ).show(context);
    });
  }
}
