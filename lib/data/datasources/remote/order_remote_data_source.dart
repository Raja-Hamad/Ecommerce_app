import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/order.dart';

class OrderRemoteDataSource {
  final _client = ApiClient.instance;

  Future<Order> createOrder({
    required String addressId,
    String? couponCode,
    required PaymentMethod paymentMethod,
  }) async {
    final response = await _client.post(
      ApiEndpoints.placeOrder,
      body: {
        'addressId': addressId,
        'paymentMethod': paymentMethod.apiValue,
        if (couponCode != null && couponCode.isNotEmpty) 'couponCode': couponCode,
      },
    );
    return Order.fromJson(response['order'] as Map<String, dynamic>);
  }
}
