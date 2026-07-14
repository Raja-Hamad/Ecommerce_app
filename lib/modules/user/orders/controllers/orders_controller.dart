import 'package:get/get.dart';
import '../../../../data/repositories/order_repository_impl.dart';
import '../../../../domain/entities/order.dart';
import '../../../../core/routes/app_routes.dart';

class OrdersController extends GetxController {
  final _repo = OrderRepositoryImpl();

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      orders.value = await _repo.getOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void openOrder(Order order) => Get.toNamed(AppRoutes.orderDetails, arguments: order.id);
}
