import '../../domain/entities/address.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/mock_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Order>> getOrders() async {
    await Future.delayed(_ds.latency);
    return _ds.orders.reversed.toList();
  }

  @override
  Future<Order> getOrderById(String id) async {
    await Future.delayed(_ds.latency);
    return _ds.orders.firstWhere((o) => o.id == id);
  }

  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required Address address,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double total,
    String? couponCode,
  }) async {
    await Future.delayed(_ds.latency);
    final order = Order(
      id: 'ORD${1000 + _ds.orders.length + 1}',
      items: items,
      address: address,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      status: OrderStatus.processing,
      paymentStatus: PaymentStatus.paid,
      createdAt: DateTime.now(),
      couponCode: couponCode,
    );
    _ds.orders.add(order);
    _ds.cart.clear();
    return order;
  }
}
