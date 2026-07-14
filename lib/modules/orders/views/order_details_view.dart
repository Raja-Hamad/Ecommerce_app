import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../domain/entities/order.dart';
import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details', style: AppTextStyles.h3)),
      body: Obx(() {
        final order = controller.order.value;
        if (controller.isLoading.value || order == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_rounded, color: AppColors.primary),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ${order.status.name}', style: AppTextStyles.h4.copyWith(color: AppColors.primaryDark)),
                          Text('Placed on ${Formatters.dateTime(order.createdAt)}', style: AppTextStyles.caption),
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
                  Text(
                    order.paymentMethod == PaymentMethod.stripe ? 'Card (Stripe)' : 'Cash on Delivery',
                    style: AppTextStyles.bodySmall,
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
              OrderSummaryCard(subtotal: order.totalAmount, discount: order.discount, deliveryFee: 0, total: order.finalAmount),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final order = controller.order.value;
        if (order == null || !order.isCancellable) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: controller.isCancelling.value ? null : controller.cancelOrder,
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
    );
  }
}
