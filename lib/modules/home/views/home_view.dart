import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/controllers/wishlist_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/section_header.dart';
import '../controllers/home_controller.dart';
import '../widgets/category_circle.dart';
import '../widgets/home_banner_carousel.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.loadHome,
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSizes.xl),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello there 👋', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                          Text(AppStrings.appName, style: AppTextStyles.h1),
                        ],
                      ),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: AppDecorations.card(radius: AppSizes.radiusMd),
                        child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      boxShadow: AppDecorations.softShadow,
                    ),
                    child: TextField(
                      controller: controller.searchCtrl,
                      onSubmitted: controller.onSearchSubmitted,
                      decoration: InputDecoration(
                        hintText: 'Search products, brands...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusPill), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                const HomeBannerCarousel(),
                const SizedBox(height: AppSizes.xl),
                SectionHeader(title: 'Categories', actionLabel: 'See All', onAction: () => Get.toNamed(AppRoutes.categories)),
                const SizedBox(height: AppSizes.md),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: controller.categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return CategoryCircle(category: category, onTap: () => controller.openCategory(category));
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                SectionHeader(
                  title: 'Featured Products',
                  actionLabel: 'See All',
                  onAction: () => Get.toNamed(AppRoutes.productListing),
                ),
                const SizedBox(height: AppSizes.md),
                Obx(() => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                      itemCount: controller.featured.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSizes.md,
                        crossAxisSpacing: AppSizes.md,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, index) {
                        final product = controller.featured[index];
                        return ProductCard(
                          product: product,
                          onTap: () => controller.openProduct(product),
                          isWishlisted: wishlist.isInWishlist(product.id),
                          onWishlistTap: () => wishlist.toggle(product),
                        );
                      },
                    )),
                const SizedBox(height: AppSizes.xl),
                const SectionHeader(title: 'Best Sellers'),
                const SizedBox(height: AppSizes.md),
                SizedBox(
                  height: 250,
                  child: Obx(() => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                        itemCount: controller.bestSellers.length,
                        separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
                        itemBuilder: (context, index) {
                          final product = controller.bestSellers[index];
                          return SizedBox(
                            width: 160,
                            child: ProductCard(
                              product: product,
                              onTap: () => controller.openProduct(product),
                              isWishlisted: wishlist.isInWishlist(product.id),
                              onWishlistTap: () => wishlist.toggle(product),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
