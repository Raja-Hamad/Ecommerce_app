import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/order.dart';

class PaymentController extends GetxController {
  final _repo = OrderRepositoryImpl();

  late final Address address;
  late final double subtotal;
  late final double discount;
  late final double deliveryFee;
  late final double total;
  String? couponCode;

  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    address = args['address'] as Address;
    subtotal = args['subtotal'] as double;
    discount = args['discount'] as double;
    deliveryFee = args['deliveryFee'] as double;
    total = args['total'] as double;
    couponCode = args['couponCode'] as String?;
  }

  Future<void> confirmPayment() async {
    isProcessing.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      final cart = Get.find<CartController>();
      final order = await _repo.placeOrder(
        items: cart.items.toList(),
        address: address,
        subtotal: subtotal,
        discount: discount,
        deliveryFee: deliveryFee,
        total: total,
        couponCode: couponCode,
      );
      await cart.clearCart();
      Get.back();
      Get.offNamed(AppRoutes.paymentSuccess, arguments: order);
    } finally {
      isProcessing.value = false;
    }
  }
}

class PaymentSuccessController extends GetxController {
  Order get order => Get.arguments as Order;
}
