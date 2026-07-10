import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _row('Subtotal', Formatters.currency(subtotal)),
          const SizedBox(height: AppSizes.sm),
          _row('Discount', discount > 0 ? '-${Formatters.currency(discount)}' : Formatters.currency(0), valueColor: discount > 0 ? AppColors.success : null),
          const SizedBox(height: AppSizes.sm),
          _row('Delivery Fee', deliveryFee == 0 ? 'Free' : Formatters.currency(deliveryFee), valueColor: deliveryFee == 0 ? AppColors.success : null),
          const Padding(padding: EdgeInsets.symmetric(vertical: AppSizes.md), child: Divider()),
          _row('Total', Formatters.currency(total), isTotal: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTextStyles.h4 : AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        Text(
          value,
          style: isTotal ? AppTextStyles.h3.copyWith(color: AppColors.primary) : AppTextStyles.label.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
