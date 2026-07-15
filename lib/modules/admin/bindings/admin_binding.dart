import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminDashboardController());
  }
}
