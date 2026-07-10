import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${controller.address.label} · ${controller.address.fullName}', style: AppTextStyles.h4),
                        Text(controller.address.fullAddress, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  GestureDetector(onTap: () => Get.back(), child: Text('Change', style: AppTextStyles.label.copyWith(color: AppColors.primary))),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Text('Order Items (${controller.cart.itemCount})', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            ...controller.cart.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Row(
                    children: [
                      Expanded(child: Text('${item.product.name} × ${item.quantity}', style: AppTextStyles.body, overflow: TextOverflow.ellipsis)),
                      Text(Formatters.currency(item.subtotal), style: AppTextStyles.label),
                    ],
                  ),
                )),
            const SizedBox(height: AppSizes.lg),
            Text('Coupon', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Obx(() {
              final coupon = controller.appliedCoupon.value;
              if (coupon == null) {
                return OutlinedButton.icon(
                  onPressed: controller.applyCoupon,
                  icon: const Icon(Icons.local_offer_outlined, size: AppSizes.iconSm),
                  label: const Text('Apply Coupon'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
                );
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(child: Text('${coupon.code} applied', style: AppTextStyles.label.copyWith(color: AppColors.primaryDark))),
                    GestureDetector(onTap: controller.removeCoupon, child: const Icon(Icons.close_rounded, size: 18, color: AppColors.primaryDark)),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSizes.xl),
            Obx(() => OrderSummaryCard(
                  subtotal: controller.subtotal,
                  discount: controller.discount,
                  deliveryFee: controller.deliveryFee,
                  total: controller.total,
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SafeArea(
          top: false,
          child: PrimaryButton(label: 'Place Order', icon: Icons.check_circle_outline_rounded, onPressed: controller.proceedToPayment),
        ),
      ),
    );
  }
}
