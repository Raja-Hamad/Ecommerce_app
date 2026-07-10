import '../entities/order.dart';
import '../entities/cart_item.dart';
import '../entities/address.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<Order> placeOrder({
    required List<CartItem> items,
    required Address address,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double total,
    String? couponCode,
  });
}
