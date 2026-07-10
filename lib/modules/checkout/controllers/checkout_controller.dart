import 'package:get/get.dart';
import '../../../core/controllers/cart_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/coupon.dart';

class CheckoutController extends GetxController {
  final cart = Get.find<CartController>();

  final Address address;
  CheckoutController({required this.address});

  final Rxn<Coupon> appliedCoupon = Rxn<Coupon>();

  double get subtotal => cart.subtotal;
  double get deliveryFee => subtotal > 50 ? 0 : 5.99;
  double get discount => appliedCoupon.value == null ? 0 : subtotal * (appliedCoupon.value!.discountPercent / 100);
  double get total => subtotal + deliveryFee - discount;

  Future<void> applyCoupon() async {
    final result = await Get.toNamed(AppRoutes.coupon, arguments: subtotal);
    if (result is Coupon) {
      appliedCoupon.value = result;
    }
  }

  void removeCoupon() => appliedCoupon.value = null;

  void proceedToPayment() {
    Get.toNamed(AppRoutes.payment, arguments: {
      'address': address,
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'couponCode': appliedCoupon.value?.code,
    });
  }
}
