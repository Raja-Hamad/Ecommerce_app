import '../entities/payment_intent.dart';

abstract class PaymentRepository {
  Future<PaymentIntentResult> createPaymentIntent(String orderId);
}
