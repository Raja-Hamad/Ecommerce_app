import 'package:get/get.dart';
import '../controllers/admin_create_product_controller.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../controllers/admin_edit_product_controller.dart';
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

class AdminEditProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminEditProductController());
  }
}

class AdminCreateProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminCreateProductController());
  }
}
