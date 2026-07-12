import '../../domain/entities/coupon.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user.dart';

class MockDataSource {
  MockDataSource._internal();
  static final MockDataSource instance = MockDataSource._internal();

  final Duration latency = const Duration(milliseconds: 500);

  AppUser? loggedInUser;

  final List<Coupon> coupons = [
    Coupon(id: 'cp1', code: 'WELCOME10', description: 'Get 10% off on your first order', discountPercent: 10, minOrderValue: 0, expiryDate: DateTime.now().add(const Duration(days: 30))),
    Coupon(id: 'cp2', code: 'SAVE20', description: '20% off on orders above \$100', discountPercent: 20, minOrderValue: 100, expiryDate: DateTime.now().add(const Duration(days: 15))),
    Coupon(id: 'cp3', code: 'MEGA30', description: '30% off on orders above \$200', discountPercent: 30, minOrderValue: 200, expiryDate: DateTime.now().add(const Duration(days: 7))),
  ];

  final List<Order> orders = [];
}
