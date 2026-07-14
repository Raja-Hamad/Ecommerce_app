import 'package:get/get.dart';
import '../../user/categories/controllers/categories_controller.dart';
import '../../user/cart/controllers/cart_view_controller.dart';
import '../../user/home/controllers/home_controller.dart';
import '../../user/orders/controllers/orders_controller.dart';
import '../../user/profile/controllers/profile_controller.dart';

class RootController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _registerTabControllers();
    final args = Get.arguments;
    final initialTab = (args is Map && args['tab'] is int) ? args['tab'] as int : 0;
    currentIndex.value = initialTab;
    // Orders is populated once by its permanent controller's onInit, so
    // landing on it directly (e.g. "Track Order" after checkout) needs an
    // explicit refresh to pick up the order that was just placed. Deferred
    // to a microtask since onInit runs synchronously during RootView's
    // build (via Get.find), and mutating an Rx here would otherwise trigger
    // "setState() called during build" on the Orders tab's Obx.
    if (initialTab == 3) {
      Future.microtask(() => Get.find<OrdersController>().fetch());
    }
  }

  void _registerTabControllers() {
    if (!Get.isRegistered<HomeController>()) Get.put(HomeController(), permanent: true);
    if (!Get.isRegistered<CategoriesController>()) Get.put(CategoriesController(), permanent: true);
    if (!Get.isRegistered<CartViewController>()) Get.put(CartViewController(), permanent: true);
    if (!Get.isRegistered<OrdersController>()) Get.put(OrdersController(), permanent: true);
    if (!Get.isRegistered<ProfileController>()) Get.put(ProfileController(), permanent: true);
  }

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 3) {
      Get.find<OrdersController>().fetch();
    }
  }
}
