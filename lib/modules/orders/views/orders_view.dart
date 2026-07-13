import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/order.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders', style: AppTextStyles.h3)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.orders.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No orders yet',
            message: 'Your placed orders will show up here',
            actionLabel: 'Start Shopping',
            onAction: () => Get.toNamed(AppRoutes.productListing),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.lg),
          itemCount: controller.orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return GestureDetector(
              onTap: () => controller.openOrder(order),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id}', style: AppTextStyles.h4),
                        _StatusBadge(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(Formatters.dateTime(order.createdAt), style: AppTextStyles.caption),
                    const Padding(padding: EdgeInsets.symmetric(vertical: AppSizes.sm), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${order.itemCount} items', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                        Text(Formatters.currency(order.finalAmount), style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final config = {
      OrderStatus.pending: (AppColors.warning, 'Pending'),
      OrderStatus.processing: (AppColors.primary, 'Processing'),
      OrderStatus.shipped: (AppColors.primary, 'Shipped'),
      OrderStatus.delivered: (AppColors.success, 'Delivered'),
      OrderStatus.cancelled: (AppColors.error, 'Cancelled'),
    }[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
      decoration: BoxDecoration(color: config.$1.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
      child: Text(config.$2, style: AppTextStyles.labelSmall.copyWith(color: config.$1)),
    );
  }
}
