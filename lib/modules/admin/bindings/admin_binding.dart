import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../controllers/admin_product_details_controller.dart';
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

class AdminProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminProductDetailsController());
  }
}
