import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}

class PaymentSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentSuccessController());
  }
}
