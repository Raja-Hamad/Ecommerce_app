import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Obx(() {
        final stats = controller.stats.value;
        if (controller.isLoading.value && stats == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.fetch,
          color: AppColors.primary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _DashboardHeader(name: auth.user.value?.name ?? 'Admin', revenue: stats?.totalRevenue ?? 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xl, AppSizes.lg, AppSizes.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overview', style: AppTextStyles.h3),
                    // const SizedBox(height: AppSizes.md),
                    GridView.count(
                      padding:  EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.md,
                      crossAxisSpacing: AppSizes.md,
                      childAspectRatio: 1.35,
                      children: [
                        _StatCard(
                          icon: Icons.people_alt_rounded,
                          color: const Color(0xFF3B82F6),
                          value: '${stats?.totalUsers ?? 0}',
                          label: 'Total Users',
                        ),
                        _StatCard(
                          icon: Icons.inventory_2_rounded,
                          color: const Color(0xFF8B5CF6),
                          value: '${stats?.totalProducts ?? 0}',
                          label: 'Total Products',
                        ),
                        _StatCard(
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.accent,
                          value: '${stats?.totalOrders ?? 0}',
                          label: 'Total Orders',
                        ),
                        _StatCard(
                          icon: Icons.local_offer_rounded,
                          color: AppColors.primary,
                          value: '${stats?.totalCoupons ?? 0}',
                          label: 'Total Coupons',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xl),
                    Text('Orders Status', style: AppTextStyles.h3),
                    const SizedBox(height: AppSizes.md),
                    _OrdersStatusCard(stats: stats),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.name, required this.revenue});

  final String name;
  final double revenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.xl, AppSizes.lg, AppSizes.xxl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSizes.radiusXl)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                      Text(name, style: AppTextStyles.h3.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      title: 'Logout?',
                      message: 'Are you sure you want to logout of your admin account?',
                      icon: Icons.logout_rounded,
                      confirmLabel: 'Logout',
                    );
                    if (confirmed) {
                      final auth = Get.find<AuthController>();
                      await auth.logout();
                      Get.offAllNamed(AppRoutes.login);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: const Icon(Icons.payments_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Revenue', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                      const SizedBox(height: 2),
                      Text(Formatters.currency(revenue), style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 26)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: AppDecorations.card(radius: AppSizes.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(value, style: AppTextStyles.h2),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _OrdersStatusCard extends StatelessWidget {
  const _OrdersStatusCard({required this.stats});

  final AdminDashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    final pending = stats?.pendingOrders ?? 0;
    final completed = stats?.completedOrders ?? 0;
    final total = pending + completed;
    final pendingFlex = total == 0 ? 1 : pending;
    final completedFlex = total == 0 ? 1 : completed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: AppDecorations.card(radius: AppSizes.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(flex: pendingFlex, child: Container(color: total == 0 ? AppColors.border : AppColors.accent)),
                  Expanded(flex: completedFlex, child: Container(color: total == 0 ? AppColors.border : AppColors.success)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _OrderStatusLegend(
                  color: AppColors.accent,
                  icon: Icons.hourglass_top_rounded,
                  label: 'Pending',
                  count: pending,
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.border),
              Expanded(
                child: _OrderStatusLegend(
                  color: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  count: completed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStatusLegend extends StatelessWidget {
  const _OrderStatusLegend({required this.color, required this.icon, required this.label, required this.count});

  final Color color;
  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$count', style: AppTextStyles.h4),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
