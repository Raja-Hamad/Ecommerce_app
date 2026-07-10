import 'package:get/get.dart';
import '../../../domain/entities/address.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    final address = Get.arguments as Address;
    Get.lazyPut(() => CheckoutController(address: address));
  }
}
