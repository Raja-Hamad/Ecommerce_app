import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Obx(() => controller.linkSent.value ? _SentState(email: controller.emailCtrl.text.trim()) : _FormState(controller: controller)),
        ),
      ),
    );
  }
}

class _FormState extends StatelessWidget {
  const _FormState({required this.controller});

  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
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
            child: const Icon(Icons.lock_reset_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Forgot password?', style: AppTextStyles.h1),
          const SizedBox(height: AppSizes.xs),
          Text(
            "No worries, enter your email and we'll send you a reset link.",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.xxl),
          CustomTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: controller.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
            validator: Validators.email,
          ),
          const SizedBox(height: AppSizes.xxl),
          Obx(() => PrimaryButton(
                label: 'Send Reset Link',
                isLoading: controller.isLoading.value,
                onPressed: controller.submit,
              )),
        ],
      ),
    );
  }
}

class _SentState extends StatelessWidget {
  const _SentState({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: AppSizes.lg),
        Text('Check your email', style: AppTextStyles.h1),
        const SizedBox(height: AppSizes.xs),
        Text(
          'We sent a password reset link to $email',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSizes.xxl),
        PrimaryButton(label: 'Back to Login', onPressed: () => Get.back()),
      ],
    );
  }
}
