import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/admin_orders_page.dart';
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

  Future<Order> getOrderById(String orderId) async {
    final response = await _client.get(ApiEndpoints.orderDetails(orderId));
    return Order.fromJson(response);
  }

  Future<AdminOrdersPage> getAllOrders({
    String? search,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? sort,
    int page = 1,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
      if (paymentStatus != null && paymentStatus.isNotEmpty) 'paymentStatus': paymentStatus,
      if (paymentMethod != null && paymentMethod.isNotEmpty) 'paymentMethod': paymentMethod,
      if (sort != null && sort.isNotEmpty) 'sort': sort,
    };
    final response = await _client.get(ApiEndpoints.adminAllOrders, query: query);
    return AdminOrdersPage.fromJson(response);
  }
}
