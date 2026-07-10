import 'package:get/get.dart';
import '../controllers/product_listing_controller.dart';

class ProductListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductListingController());
  }
}
