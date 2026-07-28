import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../domain/entities/admin_user_details.dart';
import '../controllers/admin_user_details_controller.dart';
import '../utils/order_status_helpers.dart';

class AdminUserDetailsView extends GetView<AdminUserDetailsController> {
  const AdminUserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('User Details', style: AppTextStyles.h3)),
      body: Obx(() {
        final details = controller.details.value;
        if (controller.isLoading.value || details == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = details.user;
        final stats = details.statistics;
        final isAdmin = user.role.toLowerCase() == 'admin';
        final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          child: user.profileImage.isNotEmpty
                              ? AppNetworkImage(url: user.profileImage)
                              : Center(child: Text(initial, style: AppTextStyles.h3.copyWith(color: AppColors.primary))),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTextStyles.h4.copyWith(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(user.email, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                          const SizedBox(height: AppSizes.sm),
                          Row(
                            children: [
                              if (isAdmin) ...[
                                _Chip(label: 'Admin', color: Colors.white),
                                const SizedBox(width: 6),
                              ],
                              _Chip(label: user.isActive ? 'Active' : 'Blocked', color: user.isActive ? AppColors.success : AppColors.error, solid: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Order Statistics', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.md),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.md,
                crossAxisSpacing: AppSizes.md,
                childAspectRatio: 1.7,
                children: [
                  _StatTile(label: 'Total Orders', value: '${stats.totalOrders}', icon: Icons.receipt_long_rounded, color: AppColors.primary),
                  _StatTile(label: 'Total Spent', value: Formatters.currency(stats.totalSpent), icon: Icons.payments_rounded, color: const Color(0xFF3B82F6)),
                  _StatTile(label: 'Pending', value: '${stats.pendingOrders}', icon: Icons.hourglass_top_rounded, color: AppColors.warning),
                  _StatTile(label: 'Shipped', value: '${stats.shippedOrders}', icon: Icons.local_shipping_outlined, color: const Color(0xFF8B5CF6)),
                  _StatTile(label: 'Delivered', value: '${stats.deliveredOrders}', icon: Icons.check_circle_rounded, color: AppColors.success),
                  _StatTile(label: 'Cancelled', value: '${stats.cancelledOrders}', icon: Icons.cancel_rounded, color: AppColors.error),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Recent Orders', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.md),
              if (details.recentOrders.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.xl),
                  decoration: AppDecorations.card(radius: AppSizes.radiusLg),
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: AppColors.textHint, size: 32),
                      const SizedBox(height: AppSizes.sm),
                      Text('No orders yet', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  decoration: AppDecorations.card(radius: AppSizes.radiusLg),
                  child: Column(
                    children: [
                      for (int i = 0; i < details.recentOrders.length; i++) ...[
                        _OrderSummaryTile(order: details.recentOrders[i]),
                        if (i != details.recentOrders.length - 1) const Divider(height: 1, indent: AppSizes.lg, endIndent: AppSizes.lg, color: AppColors.border),
                      ],
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, this.solid = false});

  final String label;
  final Color color;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 3),
      decoration: BoxDecoration(
        color: solid ? color.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10)),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon, required this.color});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.08), AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppTextStyles.h4.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryTile extends StatelessWidget {
  const _OrderSummaryTile({required this.order});

  final UserOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusLabel) = orderStatusConfig(order.status);
    final (paymentColor, paymentLabel) = paymentStatusConfig(order.paymentStatus);
    final shortId = order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id;

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.adminOrderDetails, arguments: order.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order #$shortId', style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 2),
                  Text(Formatters.dateTime(order.createdAt), style: AppTextStyles.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Formatters.currency(order.finalAmount), style: AppTextStyles.label),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                      child: Text(statusLabel, style: AppTextStyles.labelSmall.copyWith(color: statusColor, fontSize: 10)),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: paymentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                      child: Text(paymentLabel, style: AppTextStyles.labelSmall.copyWith(color: paymentColor, fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
