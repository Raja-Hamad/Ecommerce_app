import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update your password', style: AppTextStyles.h2),
              const SizedBox(height: AppSizes.xs),
              Text(
                'Choose a strong password you haven\'t used before.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.xxl),
              Obx(() => CustomTextField(
                    label: 'Current Password',
                    hint: 'Enter your current password',
                    controller: controller.currentPasswordCtrl,
                    obscureText: controller.obscureCurrent.value,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureCurrent.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: AppSizes.iconMd,
                        color: AppColors.textHint,
                      ),
                      onPressed: () => controller.obscureCurrent.toggle(),
                    ),
                  )),
              const SizedBox(height: AppSizes.lg),
              Obx(() => CustomTextField(
                    label: 'New Password',
                    hint: 'Enter a new password',
                    controller: controller.newPasswordCtrl,
                    obscureText: controller.obscureNew.value,
                    prefixIcon: Icons.lock_reset_rounded,
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
                    label: 'Update Password',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.save,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
