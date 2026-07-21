import '../entities/admin_orders_page.dart';
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
  Future<AdminOrdersPage> getAllOrders({
    String? search,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? sort,
    int page = 1,
  });
  Future<void> updateOrderStatus(String orderId, String status);
}
