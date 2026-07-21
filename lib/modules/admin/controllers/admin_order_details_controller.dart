import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order.dart';

class AdminOrderDetailsController extends GetxController {
  final _repo = OrderRepositoryImpl();

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetch(Get.arguments as String);
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
}
