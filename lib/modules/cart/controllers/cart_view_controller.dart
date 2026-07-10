import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/routes/app_routes.dart';

class CartViewController extends GetxController {
  final cart = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    cart.fetchCart();
  }

  void goToCheckout() => Get.toNamed(AppRoutes.address);
}
