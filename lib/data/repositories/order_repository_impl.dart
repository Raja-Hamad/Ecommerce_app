import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl._internal();
  static final OrderRepositoryImpl _instance = OrderRepositoryImpl._internal();
  factory OrderRepositoryImpl() => _instance;

  final _remote = OrderRemoteDataSource();

  // There's no "get my orders" / "get order by id" endpoint yet, so orders
  // created this session are cached locally so they show up in My Orders
  // immediately. Singleton so every screen shares the same cache.
  final List<Order> _cache = [];

  @override
  Future<List<Order>> getOrders() async => _cache.reversed.toList();

  @override
  Future<Order> getOrderById(String id) async => _cache.firstWhere((o) => o.id == id);

  @override
  Future<Order> createOrder({
    required String addressId,
    String? couponCode,
    required PaymentMethod paymentMethod,
  }) async {
    final order = await _remote.createOrder(addressId: addressId, couponCode: couponCode, paymentMethod: paymentMethod);
    _cache.add(order);
    return order;
  }
}
