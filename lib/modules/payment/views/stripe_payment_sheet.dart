import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/payment_controller.dart';

void showStripePaymentSheet(BuildContext context, PaymentController controller) {
  Get.bottomSheet(
    _StripePaymentSheet(controller: controller),
    isScrollControlled: true,
    isDismissible: true,
  );
}

class _StripePaymentSheet extends StatelessWidget {
  const _StripePaymentSheet({required this.controller});

  final PaymentController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(AppSizes.radiusPill))),
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Text('Pay ${Formatters.currency(controller.total)}', style: AppTextStyles.h2),
                const Spacer(),
                Icon(Icons.lock_rounded, color: AppColors.textHint, size: 18),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Text('stripe', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                const SizedBox(width: 4),
                Text('test mode', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            _FakeField(label: 'Card number', hint: '4242 4242 4242 4242', icon: Icons.credit_card_rounded),
            const SizedBox(height: AppSizes.md),
            Row(
              children: const [
                Expanded(child: _FakeField(label: 'Expiry', hint: '12/28')),
                SizedBox(width: AppSizes.md),
                Expanded(child: _FakeField(label: 'CVC', hint: '123')),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            const _FakeField(label: 'Cardholder name', hint: 'Hamad Raja'),
            const SizedBox(height: AppSizes.md),
            const _FakeField(label: 'Country', hint: 'United States'),
            const SizedBox(height: AppSizes.xl),
            Obx(() => PrimaryButton(
                  label: 'Pay ${Formatters.currency(controller.total)}',
                  isLoading: controller.isProcessing.value,
                  onPressed: controller.confirmPayment,
                )),
            const SizedBox(height: AppSizes.sm),
            Center(child: Text('Payments are secure and encrypted', style: AppTextStyles.caption)),
          ],
        ),
      ),
    );
  }
}

class _FakeField extends StatelessWidget {
  const _FakeField({required this.label, required this.hint, this.icon});

  final String label;
  final String hint;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: AppSizes.sm),
        Container(
          height: AppSizes.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          decoration: BoxDecoration(color: AppColors.scaffold, borderRadius: BorderRadius.circular(AppSizes.radiusMd), border: Border.all(color: AppColors.border)),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, size: AppSizes.iconMd, color: AppColors.textHint), const SizedBox(width: AppSizes.sm)],
              Text(hint, style: AppTextStyles.body.copyWith(color: AppColors.textHint)),
            ],
          ),
        ),
      ],
    );
  }
}
