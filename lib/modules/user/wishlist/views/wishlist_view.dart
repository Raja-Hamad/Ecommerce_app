import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/controllers/wishlist_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/product_card.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist', style: AppTextStyles.h3)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'Your wishlist is empty',
            message: 'Save items you love and find them here anytime',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(AppSizes.lg),
          itemCount: controller.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSizes.md,
            crossAxisSpacing: AppSizes.md,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final product = controller.items[index];
            return ProductCard(
              product: product,
              isWishlisted: true,
              onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product.id),
              onWishlistTap: () => controller.toggle(product),
            );
          },
        );
      }),
    );
  }
}
