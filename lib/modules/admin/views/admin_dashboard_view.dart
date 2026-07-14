import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Placeholder landing screen for admin/staff accounts until the admin
/// dashboard APIs and UI are built out.
class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard', style: AppTextStyles.h3)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.admin_panel_settings_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Welcome, ${auth.user.value?.name ?? 'Admin'}', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.xs),
              Text(
                'The admin dashboard is under construction. Check back soon.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xxl),
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: 'Logout',
                  outlined: true,
                  onPressed: () async {
                    await auth.logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
