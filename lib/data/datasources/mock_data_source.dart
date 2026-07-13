import '../../domain/entities/order.dart';
import '../../domain/entities/user.dart';

class MockDataSource {
  MockDataSource._internal();
  static final MockDataSource instance = MockDataSource._internal();

  final Duration latency = const Duration(milliseconds: 500);

  AppUser? loggedInUser;

  final List<Order> orders = [];
}
