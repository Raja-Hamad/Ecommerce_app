import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../controllers/admin_products_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminDashboardController());
  }
}

class AdminProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminProductsController());
  }
}
