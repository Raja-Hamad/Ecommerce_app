import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/order_summary_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/cart_view_controller.dart';
import 'widgets/cart_item_tile.dart';

class CartView extends GetView<CartViewController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = controller.cart;
    return Scaffold(
      appBar: AppBar(title: Text('My Cart', style: AppTextStyles.h3)),
      body: Obx(() {
        if (cart.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (cart.items.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Your cart is empty',
            message: 'Looks like you haven\'t added anything yet',
            actionLabel: 'Start Shopping',
            onAction: () => Get.toNamed(AppRoutes.productListing),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSizes.lg),
                itemCount: cart.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return CartItemTile(
                    item: item,
                    onIncrement: () => cart.updateQuantity(item.product.id, item.quantity + 1),
                    onDecrement: () => cart.updateQuantity(item.product.id, item.quantity - 1),
                    onRemove: () async {
                      final confirmed = await ConfirmDialog.show(
                        title: 'Remove item?',
                        message: '"${item.product.name}" will be removed from your cart.',
                      );
                      if (confirmed) cart.removeFromCart(item.product.id);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.lg),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderSummaryCard(subtotal: cart.subtotal, discount: 0, deliveryFee: cart.subtotal > 50 ? 0 : 5.99, total: cart.subtotal + (cart.subtotal > 50 ? 0 : 5.99)),
                    const SizedBox(height: AppSizes.md),
                    PrimaryButton(label: 'Proceed to Checkout', icon: Icons.arrow_forward_rounded, onPressed: controller.goToCheckout),
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
