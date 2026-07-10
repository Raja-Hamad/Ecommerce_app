import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../../../domain/entities/product.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value || controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final product = controller.product.value!;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImageGallery(product: product),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.brand.isNotEmpty)
                          Text(product.brand.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(product.name, style: AppTextStyles.h2),
                        const SizedBox(height: AppSizes.sm),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
                            const SizedBox(width: 4),
                            Text('${product.rating}', style: AppTextStyles.label),
                            const SizedBox(width: 4),
                            Text('(${product.reviewCount} reviews)', style: AppTextStyles.caption),
                            const Spacer(),
                            Text(
                              product.inStock ? 'In Stock' : 'Out of Stock',
                              style: AppTextStyles.label.copyWith(color: product.inStock ? AppColors.success : AppColors.error),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),
                        Row(
                          children: [
                            Text(Formatters.currency(product.displayPrice), style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                            if (product.hasDiscount) ...[
                              const SizedBox(width: AppSizes.sm),
                              Text(Formatters.currency(product.price), style: AppTextStyles.priceStrike),
                              const SizedBox(width: AppSizes.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                                child: Text('-${product.discountPercent}%', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                        if (product.sizes.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.lg),
                          Text('Size', style: AppTextStyles.h4),
                          const SizedBox(height: AppSizes.sm),
                          Obx(() => Wrap(
                                spacing: AppSizes.sm,
                                children: product.sizes.map((size) {
                                  final selected = controller.selectedSize.value == size;
                                  return ChoiceChip(
                                    label: Text(size),
                                    selected: selected,
                                    onSelected: (_) => controller.selectedSize.value = size,
                                    selectedColor: AppColors.primary,
                                    labelStyle: AppTextStyles.bodySmall.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
                                    backgroundColor: AppColors.surface,
                                    side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                                  );
                                }).toList(),
                              )),
                        ],
                        if (product.colors.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.lg),
                          Text('Color', style: AppTextStyles.h4),
                          const SizedBox(height: AppSizes.sm),
                          Obx(() => Wrap(
                                spacing: AppSizes.sm,
                                children: product.colors.map((color) {
                                  final selected = controller.selectedColor.value == color;
                                  return ChoiceChip(
                                    label: Text(color),
                                    selected: selected,
                                    onSelected: (_) => controller.selectedColor.value = color,
                                    selectedColor: AppColors.primary,
                                    labelStyle: AppTextStyles.bodySmall.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
                                    backgroundColor: AppColors.surface,
                                    side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                                  );
                                }).toList(),
                              )),
                        ],
                        const SizedBox(height: AppSizes.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity', style: AppTextStyles.h4),
                            Obx(() => QuantityStepper(
                                  quantity: controller.quantity.value,
                                  onIncrement: controller.incrementQuantity,
                                  onDecrement: controller.decrementQuantity,
                                )),
                          ],
                        ),
                        const SizedBox(height: AppSizes.lg),
                        Text('Description', style: AppTextStyles.h4),
                        const SizedBox(height: AppSizes.sm),
                        Text(product.description, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSizes.md,
              left: AppSizes.lg,
              child: _CircleIconButton(icon: Icons.arrow_back_rounded, onTap: () => Get.back()),
            ),
            Positioned(
              top: AppSizes.md,
              right: AppSizes.lg,
              child: Obx(() => _CircleIconButton(
                    icon: controller.isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: controller.isWishlisted ? AppColors.error : AppColors.textPrimary,
                    onTap: controller.toggleWishlist,
                  )),
            ),
            const Positioned(left: 0, right: 0, bottom: 0, child: _BottomBar()),
          ],
        );
      }),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (i) => controller.selectedImage.value = i,
            itemCount: product.images.length,
            itemBuilder: (context, index) => AppNetworkImage(url: product.images[index]),
          ),
          Positioned(
            bottom: AppSizes.md,
            left: 0,
            right: 0,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.images.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: controller.selectedImage.value == i ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: controller.selectedImage.value == i ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap, this.iconColor});

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
        child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 20),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(label: 'Add to Cart', icon: Icons.shopping_cart_outlined, outlined: true, onPressed: controller.addToCart),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: PrimaryButton(label: 'Buy Now', onPressed: controller.buyNow),
            ),
          ],
        ),
      ),
    );
  }
}
