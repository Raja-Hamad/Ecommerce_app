import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../domain/entities/order.dart';
import '../controllers/admin_order_details_controller.dart';
import '../utils/order_status_helpers.dart';

class AdminOrderDetailsView extends GetView<AdminOrderDetailsController> {
  const AdminOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Order Details', style: AppTextStyles.h3)),
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
