import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.h3)),
      body: Obx(() {
        final user = controller.auth.user.value;
        return ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.18), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (user?.profileImage.isNotEmpty ?? false)
                      ? AppNetworkImage(url: user!.profileImage)
                      : Center(
                          child: Text(
                            (user?.name.isNotEmpty == true ? user!.name[0] : '?').toUpperCase(),
                            style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                          ),
                        ),
                ),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'Guest', style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text(user?.email ?? '', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xxl),
            _ProfileTile(icon: Icons.receipt_long_outlined, label: 'My Orders', onTap: () => Get.toNamed(AppRoutes.orders)),
            _ProfileTile(icon: Icons.favorite_border_rounded, label: 'Wishlist', onTap: () => Get.toNamed(AppRoutes.wishlist)),
            _ProfileTile(icon: Icons.location_on_outlined, label: 'Addresses', onTap: () => Get.toNamed(AppRoutes.address)),
            _ProfileTile(icon: Icons.local_offer_outlined, label: 'Coupons', onTap: () => Get.toNamed(AppRoutes.coupon, arguments: 0.0)),
            _ProfileTile(icon: Icons.notifications_none_rounded, label: 'Notifications', onTap: () {}),
            _ProfileTile(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
            _ProfileTile(icon: Icons.settings_outlined, label: 'Settings', onTap: () {}),
            const SizedBox(height: AppSizes.lg),
            _ProfileTile(icon: Icons.logout_rounded, label: 'Logout', onTap: controller.logout, isDestructive: true),
          ],
        );
      }),
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
                Icon(icon, color: color, size: AppSizes.iconMd),
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
