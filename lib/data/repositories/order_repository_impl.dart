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
  Future<Order> getOrderById(String id) async {
    final orders = await _remote.getMyOrders();
    return orders.firstWhere((o) => o.id == id);
  }

  @override
  Future<Order> createOrder({
    required String addressId,
    String? couponCode,
    required PaymentMethod paymentMethod,
  }) =>
      _remote.createOrder(addressId: addressId, couponCode: couponCode, paymentMethod: paymentMethod);
}
