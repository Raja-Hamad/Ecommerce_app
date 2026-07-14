import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../domain/entities/order.dart';
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
              decoration: AppDecorations.card(radius: AppSizes.radiusLg),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.address.label.isNotEmpty
                              ? '${controller.address.label} · ${controller.address.fullName}'
                              : controller.address.fullName,
                          style: AppTextStyles.h4,
                        ),
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
            Text('Payment Method', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _PaymentMethodTile(
                        icon: Icons.credit_card_rounded,
                        label: 'Card (Stripe)',
                        selected: controller.paymentMethod.value == PaymentMethod.stripe,
                        onTap: () => controller.selectPaymentMethod(PaymentMethod.stripe),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _PaymentMethodTile(
                        icon: Icons.payments_outlined,
                        label: 'Cash on Delivery',
                        selected: controller.paymentMethod.value == PaymentMethod.cod,
                        onTap: () => controller.selectPaymentMethod(PaymentMethod.cod),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: AppSizes.xl),
            Obx(() => OrderSummaryCard(
                  subtotal: controller.subtotal,
                  discount: controller.discount,
                  deliveryFee: 0,
                  total: controller.total,
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SafeArea(
          top: false,
          child: Obx(() => PrimaryButton(
                label: 'Place Order',
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isPlacingOrder.value,
                onPressed: controller.placeOrder,
              )),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
        decoration: AppDecorations.card(radius: AppSizes.radiusLg, tinted: selected).copyWith(
          border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textHint, size: AppSizes.iconLg),
            const SizedBox(height: AppSizes.xs),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: selected ? AppColors.primary : AppColors.textPrimary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
