import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/payment_intent.dart';

class PaymentRemoteDataSource {
  final _client = ApiClient.instance;

  Future<PaymentIntentResult> createPaymentIntent(String orderId) async {
    final response = await _client.post(
      ApiEndpoints.createPaymentIntent,
      body: {'orderId': orderId},
    );
    return PaymentIntentResult(
      clientSecret: response['clientSecret'] as String,
      paymentIntentId: response['paymentIntentId'] as String,
    );
  }
}
