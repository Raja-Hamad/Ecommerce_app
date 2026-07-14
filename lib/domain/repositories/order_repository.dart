import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<Order> createOrder({
    required String addressId,
    String? couponCode,
    required PaymentMethod paymentMethod,
  });
  Future<Order> cancelOrder(String orderId);
}
