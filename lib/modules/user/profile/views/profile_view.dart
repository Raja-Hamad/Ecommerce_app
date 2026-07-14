import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Obx(() {
        final user = controller.auth.user.value;
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _ProfileHeader(name: user?.name ?? 'Guest', email: user?.email ?? '', imageUrl: user?.profileImage ?? ''),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.lg, AppSizes.lg, AppSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACCOUNT', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, letterSpacing: 0.8)),
                  const SizedBox(height: AppSizes.sm),
                  _ProfileTile(icon: Icons.receipt_long_rounded, label: 'My Orders', onTap: () => Get.toNamed(AppRoutes.orders)),
                  _ProfileTile(icon: Icons.favorite_rounded, label: 'Wishlist', onTap: () => Get.toNamed(AppRoutes.wishlist)),
                  _ProfileTile(icon: Icons.location_on_rounded, label: 'Addresses', onTap: () => Get.toNamed(AppRoutes.address)),
                  _ProfileTile(icon: Icons.local_offer_rounded, label: 'Coupons', onTap: () => Get.toNamed(AppRoutes.coupon, arguments: 0.0)),
                  const SizedBox(height: AppSizes.lg),
                  Text('PREFERENCES', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint, letterSpacing: 0.8)),
                  const SizedBox(height: AppSizes.sm),
                  _ProfileTile(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () {}),
                  _ProfileTile(icon: Icons.help_rounded, label: 'Help & Support', onTap: () {}),
                  _ProfileTile(icon: Icons.settings_rounded, label: 'Settings', onTap: () {}),
                  const SizedBox(height: AppSizes.lg),
                  _ProfileTile(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: () async {
                      final confirmed = await ConfirmDialog.show(
                        title: 'Logout?',
                        message: 'Are you sure you want to logout of your account?',
                        icon: Icons.logout_rounded,
                        confirmLabel: 'Logout',
                      );
                      if (confirmed) controller.logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email, required this.imageUrl});

  final String name;
  final String email;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xxl, AppSizes.lg, AppSizes.xxl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSizes.radiusXl)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  child: imageUrl.isNotEmpty
                      ? AppNetworkImage(url: imageUrl)
                      : Center(
                          child: Text(
                            (name.isNotEmpty ? name[0] : '?').toUpperCase(),
                            style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(name, style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 2),
            Text(email, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.label, required this.onTap, this.isDestructive = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
            decoration: AppDecorations.card(radius: AppSizes.radiusMd, color: Colors.transparent),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDestructive ? AppColors.error.withValues(alpha: 0.10) : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(icon, color: color, size: AppSizes.iconSm),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(child: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: color))),
                if (!isDestructive) const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
