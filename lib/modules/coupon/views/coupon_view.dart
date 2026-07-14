import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/coupon.dart';
import '../controllers/coupon_controller.dart';

class CouponView extends GetView<CouponController> {
  const CouponView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Coupons', style: AppTextStyles.h3)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.coupons.isEmpty) {
          return const EmptyState(
            icon: Icons.local_offer_outlined,
            title: 'No coupons available',
            message: 'Check back later for new offers',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.lg),
          itemCount: controller.coupons.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            final coupon = controller.coupons[index];
            final eligible = controller.isEligible(coupon);
            return _CouponCard(coupon: coupon, eligible: eligible, onApply: () => Get.back(result: coupon));
          },
        );
      }),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon, required this.eligible, required this.onApply});

  final Coupon coupon;
  final bool eligible;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: eligible ? 1 : 0.5,
      child: Container(
        decoration: AppDecorations.card(radius: AppSizes.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 90,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(AppSizes.radiusLg)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    coupon.isPercentage ? '${coupon.discountValue.toInt()}%' : Formatters.currency(coupon.discountValue),
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                  Text('OFF', style: AppTextStyles.labelSmall.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupon.code, style: AppTextStyles.h4),
                    const SizedBox(height: 2),
                    Text(coupon.description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(
                      eligible
                          ? 'Valid till ${Formatters.date(coupon.expiryDate)}'
                          : 'Min. order ${Formatters.currency(coupon.minOrderValue)}',
                      style: AppTextStyles.caption.copyWith(color: eligible ? AppColors.textHint : AppColors.error),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.md),
              child: OutlinedButton(
                onPressed: eligible ? onApply : null,
                style: OutlinedButton.styleFrom(minimumSize: const Size(80, 36), padding: EdgeInsets.zero),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
