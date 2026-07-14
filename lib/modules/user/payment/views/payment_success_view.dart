import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/payment_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;
    final isCod = order.paymentMethod.name == 'cod';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 52),
              ),
              const SizedBox(height: AppSizes.xl),
              Text(isCod ? 'Order Placed!' : 'Payment Successful!', style: AppTextStyles.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.sm),
              Text(
                isCod ? 'Pay in cash when your order arrives' : 'Your order has been placed successfully',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xxl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    _row('Order ID', order.id),
                    const SizedBox(height: AppSizes.sm),
                    _row('Items', '${order.itemCount}'),
                    const SizedBox(height: AppSizes.sm),
                    _row(isCod ? 'Amount Due' : 'Amount Paid', Formatters.currency(order.finalAmount)),
                    const SizedBox(height: AppSizes.sm),
                    _row(
                      'Payment Status',
                      isCod ? 'Cash on Delivery' : 'Paid',
                      valueColor: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              PrimaryButton(
                label: 'Track Order',
                onPressed: () => Get.offAllNamed(AppRoutes.root, arguments: {'tab': 3}),
              ),
              const SizedBox(height: AppSizes.sm),
              PrimaryButton(
                label: 'Continue Shopping',
                outlined: true,
                onPressed: () => Get.offAllNamed(AppRoutes.root),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.label.copyWith(color: valueColor)),
      ],
    );
  }
}
