import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../categories/views/categories_view.dart';
import '../../cart/views/cart_view.dart';
import '../../home/views/home_view.dart';
import '../../orders/views/orders_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeView(),
      CategoriesView(),
      CartView(),
      OrdersView(),
      ProfileView(),
    ];

    final cart = Get.find<CartController>();

    return Obx(() => Scaffold(
          body: IndexedStack(index: controller.currentIndex.value, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Categories'),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: cart.itemCount > 0,
                  label: Text('${cart.itemCount}'),
                  backgroundColor: AppColors.accent,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: const Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ));
  }
}
