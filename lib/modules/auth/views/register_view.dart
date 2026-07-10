import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/auth_form_controller.dart';

class RegisterView extends GetView<AuthFormController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create account', style: AppTextStyles.h1),
                const SizedBox(height: AppSizes.xs),
                Text('Sign up to get started', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSizes.xxl),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: controller.nameCtrl,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => Validators.notEmpty(v, field: 'Name'),
                ),
                const SizedBox(height: AppSizes.lg),
                CustomTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller.registerEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSizes.lg),
                Obx(() => CustomTextField(
                      label: 'Password',
                      hint: 'Create a password',
                      controller: controller.registerPasswordCtrl,
                      obscureText: controller.obscureRegisterPassword.value,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureRegisterPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: AppSizes.iconMd,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => controller.obscureRegisterPassword.toggle(),
                      ),
                    )),
                const SizedBox(height: AppSizes.xxl),
                Obx(() => PrimaryButton(
                      label: 'Create Account',
                      isLoading: auth.isLoading.value,
                      onPressed: controller.submitRegister,
                    )),
                const SizedBox(height: AppSizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text('Sign In', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
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
