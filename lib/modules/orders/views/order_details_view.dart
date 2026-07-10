import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../domain/entities/order.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as Order;
    return Scaffold(
      appBar: AppBar(title: Text(order.id, style: AppTextStyles.h3)),
      body: SingleChildScrollView(
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
            Text('Delivery Address', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Text('${order.address.fullName}\n${order.address.fullAddress}\n${order.address.phone}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: AppSizes.xl),
            Text('Items (${order.itemCount})', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Row(
                    children: [
                      SizedBox(width: 56, height: 56, child: AppNetworkImage(url: item.product.images.first, borderRadius: BorderRadius.circular(AppSizes.radiusSm))),
                      const SizedBox(width: AppSizes.md),
                      Expanded(child: Text('${item.product.name} × ${item.quantity}', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis)),
                      Text(Formatters.currency(item.subtotal), style: AppTextStyles.label),
                    ],
                  ),
                )),
            const SizedBox(height: AppSizes.lg),
            OrderSummaryCard(subtotal: order.subtotal, discount: order.discount, deliveryFee: order.deliveryFee, total: order.total),
          ],
        ),
      ),
    );
  }
}
