import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/auth_form_controller.dart';

class LoginView extends GetView<AuthFormController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xxl),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: AppSizes.lg),
                Text('Welcome back', style: AppTextStyles.h1),
                const SizedBox(height: AppSizes.xs),
                Text('Sign in to continue shopping with ${AppStrings.appName}', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSizes.xxl),
                CustomTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller.loginEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSizes.lg),
                Obx(() => CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: controller.loginPasswordCtrl,
                      obscureText: controller.obscureLoginPassword.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureLoginPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: AppSizes.iconMd,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => controller.obscureLoginPassword.toggle(),
                      ),
                    )),
                const SizedBox(height: AppSizes.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => Get.toNamed(AppRoutes.forgotPassword), child: const Text('Forgot Password?')),
                ),
                const SizedBox(height: AppSizes.lg),
                Obx(() => PrimaryButton(
                      label: 'Sign In',
                      isLoading: auth.isLoading.value,
                      onPressed: controller.submitLogin,
                    )),
                const SizedBox(height: AppSizes.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text('Sign Up', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
