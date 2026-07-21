import '../../domain/entities/admin_orders_page.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final _remote = OrderRemoteDataSource();

  @override
  Future<List<Order>> getOrders() async {
    final orders = await _remote.getMyOrders();
    return orders.reversed.toList();
  }

  @override
  Future<Order> getOrderById(String id) => _remote.getOrderById(id);

  @override
  Future<Order> createOrder({
    required String addressId,
    String? couponCode,
    required PaymentMethod paymentMethod,
  }) =>
      _remote.createOrder(addressId: addressId, couponCode: couponCode, paymentMethod: paymentMethod);

  @override
  Future<Order> cancelOrder(String orderId) => _remote.cancelOrder(orderId);

  @override
  Future<AdminOrdersPage> getAllOrders({
    String? search,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? sort,
    int page = 1,
  }) =>
      _remote.getAllOrders(
        search: search,
        status: status,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        sort: sort,
        page: page,
      );

  @override
  Future<void> updateOrderStatus(String orderId, String status) => _remote.updateOrderStatus(orderId, status);
}
