import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
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
          itemBuilder: (context, index) => _OrderCard(order: controller.orders[index], onTap: () => controller.openOrder(controller.orders[index])),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final thumbnails = order.items.where((i) => i.product != null).toList();
    final extraCount = thumbnails.length - 4;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.radiusLg), border: Border.all(color: AppColors.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id}',
                      style: AppTextStyles.h4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(Formatters.dateTime(order.createdAt), style: AppTextStyles.caption),
              const SizedBox(height: AppSizes.md),
              if (thumbnails.isNotEmpty)
                SizedBox(
                  height: 52,
                  child: Row(
                    children: [
                      ...thumbnails.take(4).map((i) => Padding(
                            padding: const EdgeInsets.only(right: AppSizes.xs),
                            child: SizedBox(
                              width: 52,
                              height: 52,
                              child: AppNetworkImage(url: i.product!.firstImageUrl, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                            ),
                          )),
                      if (extraCount > 0)
                        Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.scaffold, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                          child: Text('+$extraCount', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: AppSizes.iconSm, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${order.shippingAddress.city}, ${order.shippingAddress.country}',
                      style: AppTextStyles.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Icon(
                    order.paymentMethod == PaymentMethod.stripe ? Icons.credit_card_rounded : Icons.payments_outlined,
                    size: AppSizes.iconSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(order.paymentMethod == PaymentMethod.stripe ? 'Card' : 'COD', style: AppTextStyles.caption),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: AppSizes.sm), child: Divider()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${order.itemCount} items', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(width: AppSizes.sm),
                      _PaymentStatusBadge(status: order.paymentStatus),
                    ],
                  ),
                  Row(
                    children: [
                      Text(Formatters.currency(order.finalAmount), style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({required this.status});
  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final config = {
      PaymentStatus.pending: (AppColors.warning, Icons.schedule_rounded, 'Payment Pending'),
      PaymentStatus.paid: (AppColors.success, Icons.check_circle_rounded, 'Paid'),
      PaymentStatus.failed: (AppColors.error, Icons.error_rounded, 'Payment Failed'),
    }[status]!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(config.$2, size: 13, color: config.$1),
        const SizedBox(width: 2),
        Text(config.$3, style: AppTextStyles.caption.copyWith(color: config.$1, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
