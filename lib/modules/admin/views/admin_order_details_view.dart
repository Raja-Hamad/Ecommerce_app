import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../domain/entities/order.dart';
import '../controllers/admin_order_details_controller.dart';
import '../utils/order_status_helpers.dart';
import '../widgets/admin_filter_widgets.dart';

class AdminOrderDetailsView extends GetView<AdminOrderDetailsController> {
  const AdminOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Order Details', style: AppTextStyles.h3)),
      bottomNavigationBar: Obx(() {
        if (!controller.canCancel) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(color: AppColors.surface, boxShadow: AppDecorations.softShadow),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: controller.isCancelling.value
                    ? null
                    : () async {
                        final confirmed = await ConfirmDialog.show(
                          title: 'Cancel Order?',
                          message: 'This order will be cancelled. This cannot be undone.',
                          confirmLabel: 'Cancel Order',
                          cancelLabel: 'Keep Order',
                        );
                        if (confirmed) controller.cancelOrder();
                      },
                icon: controller.isCancelling.value
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.error))
                    : const Icon(Icons.cancel_outlined, color: AppColors.error),
                label: Text('Cancel Order', style: AppTextStyles.label.copyWith(color: AppColors.error)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
              ),
            ),
          ),
        );
      }),
      body: Obx(() {
        final order = controller.order.value;
        if (controller.isLoading.value || order == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final (statusColor, statusLabel) = orderStatusConfig(order.status);
        final (paymentColor, paymentLabel) = paymentStatusConfig(order.paymentStatus);
        final shortId = order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id;

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #$shortId', style: AppTextStyles.h3.copyWith(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Placed on ${Formatters.dateTime(order.createdAt)}', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                      child: Text(statusLabel, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Update Status', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.sm),
              _StatusUpdateField(order: order),
              const SizedBox(height: AppSizes.xl),
              Text('Customer', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: AppDecorations.card(radius: AppSizes.radiusLg),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          (order.customerName?.isNotEmpty ?? false) ? order.customerName![0].toUpperCase() : '?',
                          style: AppTextStyles.label.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.customerName ?? 'Unknown', style: AppTextStyles.bodyLarge),
                          if (order.customerEmail != null) Text(order.customerEmail!, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Payment', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Icon(order.paymentMethod == PaymentMethod.stripe ? Icons.credit_card_rounded : Icons.payments_outlined, size: AppSizes.iconSm, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.sm),
                  Text(order.paymentMethod == PaymentMethod.stripe ? 'Card (Stripe)' : 'Cash on Delivery', style: AppTextStyles.bodySmall),
                  const SizedBox(width: AppSizes.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 3),
                    decoration: BoxDecoration(color: paymentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    child: Text(paymentLabel, style: AppTextStyles.labelSmall.copyWith(color: paymentColor)),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Delivery Address', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.sm),
              Text(
                '${order.shippingAddress.fullName}\n${order.shippingAddress.fullAddress}\n${order.shippingAddress.phone}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Items (${order.itemCount})', style: AppTextStyles.h4),
              const SizedBox(height: AppSizes.sm),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: item.product != null
                              ? AppNetworkImage(url: item.product!.firstImageUrl, borderRadius: BorderRadius.circular(AppSizes.radiusSm))
                              : Container(
                                  decoration: BoxDecoration(color: AppColors.scaffold, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                                  child: const Icon(Icons.inventory_2_outlined, color: AppColors.textHint, size: 20),
                                ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.product != null)
                                Text(item.product!.name, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('Qty ${item.quantity} × ${Formatters.currency(item.price)}', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Text(Formatters.currency(item.subtotal), style: AppTextStyles.label),
                      ],
                    ),
                  )),
              const SizedBox(height: AppSizes.lg),
              if (order.couponCode != null) ...[
                Row(
                  children: [
                    const Icon(Icons.local_offer_outlined, size: AppSizes.iconSm, color: AppColors.primary),
                    const SizedBox(width: AppSizes.sm),
                    Text('Coupon applied: ${order.couponCode}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
              ],
              OrderSummaryCard(subtotal: order.totalAmount, discount: order.discount, deliveryFee: 0, total: order.finalAmount),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusUpdateField extends StatelessWidget {
  const _StatusUpdateField({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminOrderDetailsController>();
    final selectable = controller.selectableStatuses;
    final (currentColor, currentLabel) = orderStatusConfig(order.status);

    // Delivered is the final stage and cancelled orders can't be
    // progressed — nothing left to pick from either way.
    if (selectable.length <= 1) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: AppDecorations.card(radius: AppSizes.radiusLg),
        child: Row(
          children: [
            Icon(Icons.lock_outline_rounded, size: AppSizes.iconSm, color: AppColors.textHint),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                order.status == OrderStatus.cancelled
                    ? 'This order was cancelled — status can no longer be changed.'
                    : 'Order delivered — no further status changes possible.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      final isUpdating = controller.isUpdatingStatus.value;
      return Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          onTap: isUpdating
              ? null
              : () => AdminOptionsSheet.show<OrderStatus>(
                    context,
                    title: 'Update Order Status',
                    options: selectable.map((s) => (s, orderStatusConfig(s).$2)).toList(),
                    selected: order.status,
                    onSelect: (newStatus) async {
                      if (newStatus == order.status) return;
                      final label = orderStatusConfig(newStatus).$2;
                      final confirmed = await ConfirmDialog.show(
                        title: 'Mark as $label?',
                        message: 'This will update the order status to "$label". This action cannot be reversed.',
                        icon: Icons.local_shipping_outlined,
                        confirmLabel: 'Confirm',
                        isDestructive: false,
                      );
                      if (confirmed) controller.updateStatus(newStatus);
                    },
                  ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.radiusMd), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 3),
                  decoration: BoxDecoration(color: currentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                  child: Text(currentLabel, style: AppTextStyles.labelSmall.copyWith(color: currentColor)),
                ),
                const Spacer(),
                if (isUpdating)
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
              ],
            ),
          ),
        ),
      );
    });
  }
}
