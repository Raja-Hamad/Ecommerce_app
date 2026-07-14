import 'package:get/get.dart';
import '../controllers/coupon_controller.dart';

class CouponBinding extends Bindings {
  @override
  void dependencies() {
    final orderValue = (Get.arguments is double) ? Get.arguments as double : 0.0;
    Get.lazyPut(() => CouponController(orderValue: orderValue));
  }
}
