import 'package:get/get.dart';
import '../controllers/cart_view_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartViewController());
  }
}
