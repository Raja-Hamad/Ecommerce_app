import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/controllers/cart_controller.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/repositories/payment_repository_impl.dart';
import '../../../../domain/entities/order.dart';

class PaymentController extends GetxController {
  final _paymentRepo = PaymentRepositoryImpl();

  late final Order order;

  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    order = Get.arguments as Order;
  }

  Future<void> confirmPayment() async {
    isProcessing.value = true;
    try {
      final intent = await _paymentRepo.createPaymentIntent(order.id);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: AppStrings.appName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      final cart = Get.find<CartController>();
      await cart.clearCart();
      Get.offNamed(AppRoutes.paymentSuccess, arguments: order);
    } on StripeException catch (e) {
      if (e.error.code != FailureCode.Canceled) {
        AppSnackbar.error(e.error.localizedMessage ?? 'Payment failed. Please try again.');
      }
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Payment failed. Please try again.');
    } finally {
      isProcessing.value = false;
    }
  }
}

class PaymentSuccessController extends GetxController {
  Order get order => Get.arguments as Order;
}
