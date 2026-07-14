import 'package:get/get.dart';
import '../../../../core/controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<WishlistController>().fetchWishlist();
  }
}
