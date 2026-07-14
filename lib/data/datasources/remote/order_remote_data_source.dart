import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/order.dart';

class OrderRemoteDataSource {
  final _client = ApiClient.instance;

  Future<List<Order>> getMyOrders() async {
    final response = await _client.get(ApiEndpoints.myOrders);
    final data = response['orders'] as List<dynamic>? ?? [];
    return data.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
  }

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

  Future<Order> cancelOrder(String orderId) async {
    final response = await _client.put(ApiEndpoints.cancelOrder(orderId));
    return Order.fromJson(response['order'] as Map<String, dynamic>);
  }
}
