import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order.dart';

class AdminOrderDetailsController extends GetxController {
  final _repo = OrderRepositoryImpl();

  // The only progression an order is allowed to move through; going
  // backward (e.g. shipped -> confirmed) is never permitted once set.
  static const statusSequence = [OrderStatus.pending, OrderStatus.confirmed, OrderStatus.shipped, OrderStatus.delivered];

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = true.obs;
  final RxBool isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch(Get.arguments as String);
  }

  /// Current status plus everything ahead of it in [statusSequence].
  /// Empty once the order is delivered or cancelled — no further change possible.
  List<OrderStatus> get selectableStatuses {
    final current = order.value?.status;
    if (current == null) return [];
    final index = statusSequence.indexOf(current);
    if (index == -1) return [];
    return statusSequence.sublist(index);
  }

  Future<void> fetch(String id) async {
    isLoading.value = true;
    try {
      order.value = await _repo.getOrderById(id);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load order. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(OrderStatus newStatus) async {
    final current = order.value;
    if (current == null || newStatus == current.status) return;
    isUpdatingStatus.value = true;
    try {
      await _repo.updateOrderStatus(current.id, newStatus.name);
      order.value = current.copyWith(status: newStatus);
      AppSnackbar.success('Order status updated');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update order status. Please try again.');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
