import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/payment_controller.dart';
import 'stripe_payment_sheet.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment', style: AppTextStyles.h3)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummaryCard(subtotal: controller.subtotal, discount: controller.discount, deliveryFee: controller.deliveryFee, total: controller.total),
            const SizedBox(height: AppSizes.xl),
            Text('Deliver to', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSizes.md),
                  Expanded(child: Text(controller.address.fullAddress, style: AppTextStyles.bodySmall)),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Text('Pay with', style: AppTextStyles.h4),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.md),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg), border: Border.all(color: AppColors.primary, width: 1.4)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    child: const Icon(Icons.credit_card_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pay with Card', style: AppTextStyles.h4),
                        Text('Secured by Stripe', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.radio_button_checked_rounded, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SafeArea(
          top: false,
          child: PrimaryButton(
            label: 'Pay ${Formatters.currency(controller.total)}',
            icon: Icons.lock_outline_rounded,
            onPressed: () => showStripePaymentSheet(context, controller),
          ),
        ),
      ),
    );
  }
}
