import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../domain/entities/product.dart';
import '../controllers/admin_product_details_controller.dart';

class AdminProductDetailsView extends GetView<AdminProductDetailsController> {
  const AdminProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text('Product Details', style: AppTextStyles.h3)),
      body: Obx(() {
        if (controller.isLoading.value || controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final product = controller.product.value!;
        final inStock = product.inStock;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageGallery(product: product),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.brand.isNotEmpty) ...[
                            Text(
                              product.brand.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 3),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: AppTextStyles.h2,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.sm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (inStock
                                              ? AppColors.success
                                              : AppColors.error)
                                          .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusSm,
                                  ),
                                ),
                                child: Text(
                                  inStock ? 'Active' : 'Out of Stock',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: inStock
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.star,
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${product.rating}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '(${product.reviewCount} reviews)',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.md),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.currency(product.displayPrice),
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 26,
                                ),
                              ),
                              if (product.hasDiscount) ...[
                                const SizedBox(width: AppSizes.sm),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    Formatters.currency(product.price),
                                    style: AppTextStyles.priceStrike,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      '-${product.discountPercent}%',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSizes.lg),
                          Container(
                            padding: const EdgeInsets.all(AppSizes.md),
                            decoration: AppDecorations.card(
                              radius: AppSizes.radiusLg,
                            ),
                            child: Column(
                              children: [
                                _InfoRow(
                                  label: 'Stock',
                                  value: '${product.stock} units',
                                ),
                                if (controller.categoryName.isNotEmpty) ...[
                                  const Divider(
                                    height: AppSizes.lg,
                                    color: AppColors.border,
                                  ),
                                  _InfoRow(
                                    label: 'Category',
                                    value: controller.categoryName,
                                  ),
                                ],
                                if (product.brand.isNotEmpty) ...[
                                  const Divider(
                                    height: AppSizes.lg,
                                    color: AppColors.border,
                                  ),
                                  _InfoRow(
                                    label: 'Brand',
                                    value: product.brand,
                                  ),
                                ],
                                if (product.isFeatured) ...[
                                  const Divider(
                                    height: AppSizes.lg,
                                    color: AppColors.border,
                                  ),
                                  const _InfoRow(
                                    label: 'Featured',
                                    value: 'Yes',
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (product.sizes.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.lg),
                            Text('Sizes', style: AppTextStyles.label),
                            const SizedBox(height: AppSizes.sm),
                            Wrap(
                              spacing: AppSizes.sm,
                              runSpacing: AppSizes.sm,
                              children: product.sizes
                                  .map(
                                    (s) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.md,
                                        vertical: AppSizes.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusSm,
                                        ),
                                      ),
                                      child: Text(
                                        s,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          if (product.colors.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.lg),
                            Text('Colors', style: AppTextStyles.label),
                            const SizedBox(height: AppSizes.sm),
                            Wrap(
                              spacing: AppSizes.sm,
                              runSpacing: AppSizes.sm,
                              children: product.colors
                                  .map(
                                    (c) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.md,
                                        vertical: AppSizes.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusSm,
                                        ),
                                      ),
                                      child: Text(
                                        c,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          const SizedBox(height: AppSizes.lg),
                          Text('Description', style: AppTextStyles.label),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            product.description.isNotEmpty
                                ? product.description
                                : 'No description provided.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppDecorations.softShadow,
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            AppSnackbar.info('Edit product is coming soon'),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit Product'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.md,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            AppSnackbar.info('Delete product is coming soon'),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.error,
                        ),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: AppColors.error),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.md,
                          ),
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(value, style: AppTextStyles.bodyLarge),
      ],
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminProductDetailsController>();
    if (product.images.isEmpty) {
      return Container(
        height: 300,
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.primary,
          size: 40,
        ),
      );
    }
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (i) => controller.selectedImage.value = i,
            itemCount: product.images.length,
            itemBuilder: (context, index) =>
                AppNetworkImage(url: product.images[index]),
          ),
          if (product.images.length > 1)
            Positioned(
              bottom: AppSizes.md,
              left: 0,
              right: 0,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.images.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: controller.selectedImage.value == i ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: controller.selectedImage.value == i
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusPill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
