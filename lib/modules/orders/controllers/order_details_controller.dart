import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order.dart';
import 'orders_controller.dart';

class OrderDetailsController extends GetxController {
  final _repo = OrderRepositoryImpl();

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = true.obs;
  final RxBool isCancelling = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch(Get.arguments as String);
  }

  Future<void> fetch(String id) async {
    isLoading.value = true;
    try {
      order.value = await _repo.getOrderById(id);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder() async {
    final current = order.value;
    if (current == null) return;

    final confirmed = await ConfirmDialog.show(
      title: 'Cancel order?',
      message: 'Order #${current.id.length > 8 ? current.id.substring(current.id.length - 8).toUpperCase() : current.id} will be cancelled. This cannot be undone.',
      confirmLabel: 'Cancel Order',
      cancelLabel: 'Keep Order',
    );
    if (!confirmed) return;

    isCancelling.value = true;
    try {
      await _repo.cancelOrder(current.id);
      await fetch(current.id);
      AppSnackbar.success('Order cancelled');
      if (Get.isRegistered<OrdersController>()) {
        Get.find<OrdersController>().fetch();
      }
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not cancel order. Please try again.');
    } finally {
      isCancelling.value = false;
    }
  }
}
