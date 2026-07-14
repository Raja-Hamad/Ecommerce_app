import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/controllers/wishlist_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/product_card.dart';
import '../controllers/product_listing_controller.dart';

class ProductListingView extends GetView<ProductListingController> {
  const ProductListingView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value, style: AppTextStyles.h3, overflow: TextOverflow.ellipsis)),
        actions: [
          Obx(() => IconButton(
                icon: Icon(controller.isGridView.value ? Icons.view_list_rounded : Icons.grid_view_rounded),
                onPressed: controller.toggleView,
              )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.sm),
            child: Row(
              children: [
                Expanded(child: _PillActionButton(icon: Icons.swap_vert_rounded, label: 'Sort', onTap: () => _openSortSheet(context))),
                const SizedBox(width: AppSizes.md),
                Expanded(child: _PillActionButton(icon: Icons.tune_rounded, label: 'Filter', onTap: () => _openFilterSheet(context))),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.displayed.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No products found',
                  message: 'Try adjusting your filters or search terms',
                );
              }
              if (controller.isGridView.value) {
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
                  itemCount: controller.displayed.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSizes.md,
                    crossAxisSpacing: AppSizes.md,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.displayed[index];
                    return ProductCard(
                      product: product,
                      onTap: () => controller.openProduct(product),
                      isWishlisted: wishlist.isInWishlist(product.id),
                      onWishlistTap: () => wishlist.toggle(product),
                    );
                  },
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
                itemCount: controller.displayed.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
                itemBuilder: (context, index) {
                  final product = controller.displayed[index];
                  return _ProductListTile(
                    product: product,
                    isWishlisted: wishlist.isInWishlist(product.id),
                    onTap: () => controller.openProduct(product),
                    onWishlistTap: () => wishlist.toggle(product),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openSortSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort By', style: AppTextStyles.h3),
            const SizedBox(height: AppSizes.md),
            ..._sortLabels.entries.map((entry) => Obx(() {
                  final selected = controller.sortOption.value == entry.key;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.value, style: AppTextStyles.body),
                    trailing: Icon(
                      selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: selected ? AppColors.primary : AppColors.textHint,
                    ),
                    onTap: () {
                      controller.setSort(entry.key);
                      Get.back();
                    },
                  );
                })),
          ],
        ),
      ),
    );
  }

  static const Map<SortOption, String> _sortLabels = {
    SortOption.relevance: 'Relevance',
    SortOption.priceLowHigh: 'Price: Low to High',
    SortOption.priceHighLow: 'Price: High to Low',
    SortOption.rating: 'Highest Rated',
  };

  void _openFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Max Price: ${Formatters.currency(controller.maxPrice.value)}', style: AppTextStyles.h3),
                Slider(
                  value: controller.maxPrice.value,
                  min: 10,
                  max: 300,
                  activeColor: AppColors.primary,
                  onChanged: controller.setMaxPrice,
                ),
                const SizedBox(height: AppSizes.sm),
              ],
            )),
      ),
    );
  }
}

class _PillActionButton extends StatelessWidget {
  const _PillActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        child: Container(
          height: 42,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.radiusPill), boxShadow: AppDecorations.softShadow),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSizes.iconSm, color: AppColors.textPrimary),
              const SizedBox(width: AppSizes.xs),
              Text(label, style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.product, required this.isWishlisted, required this.onTap, required this.onWishlistTap});

  final dynamic product;
  final bool isWishlisted;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: AppDecorations.card(radius: AppSizes.radiusLg, color: Colors.transparent),
          child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: AppNetworkImage(url: product.firstImageUrl, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                      const SizedBox(width: 2),
                      Text('${product.rating} (${product.reviewCount})', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(Formatters.currency(product.displayPrice), style: AppTextStyles.price.copyWith(fontSize: 15)),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(Formatters.currency(product.price), style: AppTextStyles.priceStrike),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isWishlisted ? AppColors.error : AppColors.textHint),
              onPressed: onWishlistTap,
            ),
          ],
          ),
        ),
      ),
    );
  }
}
