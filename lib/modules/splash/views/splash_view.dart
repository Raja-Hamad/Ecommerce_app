import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: const Icon(Icons.shopping_bag_rounded, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(AppStrings.appName, style: AppTextStyles.h1.copyWith(color: Colors.white)),
            const SizedBox(height: AppSizes.xs),
            Text(AppStrings.tagline, style: AppTextStyles.body.copyWith(color: Colors.white70)),
            const SizedBox(height: AppSizes.xxl * 2),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
