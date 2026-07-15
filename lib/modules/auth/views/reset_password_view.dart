import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.password_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: AppSizes.lg),
                Text('Set new password', style: AppTextStyles.h1),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Your new password must be different from previously used passwords.',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSizes.xxl),
                Obx(() => CustomTextField(
                      label: 'New Password',
                      hint: 'Enter a new password',
                      controller: controller.newPasswordCtrl,
                      obscureText: controller.obscureNew.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: controller.validateNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureNew.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: AppSizes.iconMd,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => controller.obscureNew.toggle(),
                      ),
                    )),
                const SizedBox(height: AppSizes.lg),
                Obx(() => CustomTextField(
                      label: 'Confirm New Password',
                      hint: 'Re-enter your new password',
                      controller: controller.confirmPasswordCtrl,
                      obscureText: controller.obscureConfirm.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: controller.validateConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureConfirm.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: AppSizes.iconMd,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => controller.obscureConfirm.toggle(),
                      ),
                    )),
                const SizedBox(height: AppSizes.xxl),
                Obx(() => PrimaryButton(
                      label: 'Reset Password',
                      isLoading: controller.isSaving.value,
                      onPressed: controller.save,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
