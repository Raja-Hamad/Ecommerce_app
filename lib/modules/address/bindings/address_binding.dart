import 'package:get/get.dart';
import '../controllers/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressController());
  }
}

class AddAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddAddressController());
  }
}
