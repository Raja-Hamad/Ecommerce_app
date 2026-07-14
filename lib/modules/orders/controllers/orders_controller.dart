import 'package:get/get.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/confirm_dialog.dart';

class OrdersController extends GetxController {
  final _repo = OrderRepositoryImpl();

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isCancelling = false.obs;

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

  void openOrder(Order order) => Get.toNamed(AppRoutes.orderDetails, arguments: order);

  Future<bool> cancelOrder(Order order) async {
    final confirmed = await ConfirmDialog.show(
      title: 'Cancel order?',
      message: 'Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id} will be cancelled. This cannot be undone.',
      confirmLabel: 'Cancel Order',
      cancelLabel: 'Keep Order',
    );
    if (!confirmed) return false;

    isCancelling.value = true;
    try {
      await _repo.cancelOrder(order.id);
      await fetch();
      AppSnackbar.success('Order cancelled');
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not cancel order. Please try again.');
      return false;
    } finally {
      isCancelling.value = false;
    }
  }
}
