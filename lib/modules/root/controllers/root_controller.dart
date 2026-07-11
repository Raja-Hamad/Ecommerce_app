import 'package:get/get.dart';
import '../../categories/controllers/categories_controller.dart';
import '../../cart/controllers/cart_view_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class RootController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _registerTabControllers();
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      currentIndex.value = args['tab'] as int;
    }
  }

  void _registerTabControllers() {
    if (!Get.isRegistered<HomeController>()) Get.put(HomeController(), permanent: true);
    if (!Get.isRegistered<CategoriesController>()) Get.put(CategoriesController(), permanent: true);
    if (!Get.isRegistered<CartViewController>()) Get.put(CartViewController(), permanent: true);
    if (!Get.isRegistered<OrdersController>()) Get.put(OrdersController(), permanent: true);
    if (!Get.isRegistered<ProfileController>()) Get.put(ProfileController(), permanent: true);
  }

  void changeTab(int index) => currentIndex.value = index;
}
