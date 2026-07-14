import 'package:get/get.dart';
import '../../../../core/controllers/cart_controller.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/repositories/order_repository_impl.dart';
import '../../../../domain/entities/address.dart';
import '../../../../domain/entities/coupon.dart';
import '../../../../domain/entities/order.dart';

class CheckoutController extends GetxController {
  final _repo = OrderRepositoryImpl();
  final cart = Get.find<CartController>();

  final Address address;
  CheckoutController({required this.address});

  final Rxn<Coupon> appliedCoupon = Rxn<Coupon>();
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.stripe.obs;
  final RxBool isPlacingOrder = false.obs;

  double get subtotal => cart.subtotal;
  double get discount => appliedCoupon.value?.discountFor(subtotal) ?? 0;
  double get total => subtotal - discount;

  Future<void> applyCoupon() async {
    final result = await Get.toNamed(AppRoutes.coupon, arguments: subtotal);
    if (result is Coupon) {
      appliedCoupon.value = result;
    }
  }

  void removeCoupon() => appliedCoupon.value = null;

  void selectPaymentMethod(PaymentMethod method) => paymentMethod.value = method;

  Future<void> placeOrder() async {
    isPlacingOrder.value = true;
    try {
      final order = await _repo.createOrder(
        addressId: address.id,
        couponCode: appliedCoupon.value?.code,
        paymentMethod: paymentMethod.value,
      );
      if (order.paymentMethod == PaymentMethod.stripe) {
        Get.toNamed(AppRoutes.payment, arguments: order);
      } else {
        await cart.clearCart();
        Get.offNamed(AppRoutes.paymentSuccess, arguments: order);
      }
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Could not place order. Please try again.');
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
