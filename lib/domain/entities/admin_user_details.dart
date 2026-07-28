import 'order.dart';
import 'recent_user.dart';

class UserStatistics {
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final double totalSpent;

  const UserStatistics({
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.totalSpent,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      processingOrders: (json['processingOrders'] as num?)?.toInt() ?? 0,
      shippedOrders: (json['shippedOrders'] as num?)?.toInt() ?? 0,
      deliveredOrders: (json['deliveredOrders'] as num?)?.toInt() ?? 0,
      cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
    );
  }
}

class UserOrderSummary {
  final String id;
  final double totalAmount;
  final double finalAmount;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus status;
  final DateTime createdAt;

  const UserOrderSummary({
    required this.id,
    required this.totalAmount,
    required this.finalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
  });

  factory UserOrderSummary.fromJson(Map<String, dynamic> json) {
    return UserOrderSummary(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0,
      paymentMethod: PaymentMethodApi.fromApi(json['paymentMethod'] as String?),
      paymentStatus: parsePaymentStatus(json['paymentStatus'] as String?),
      status: parseOrderStatus(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class AdminUserDetails {
  final RecentUser user;
  final UserStatistics statistics;
  final List<UserOrderSummary> recentOrders;

  const AdminUserDetails({
    required this.user,
    required this.statistics,
    required this.recentOrders,
  });

  factory AdminUserDetails.fromJson(Map<String, dynamic> json) {
    final ordersJson = json['recentOrders'] as List<dynamic>? ?? [];
    return AdminUserDetails(
      user: RecentUser.fromJson(json['user'] as Map<String, dynamic>? ?? const {}),
      statistics: UserStatistics.fromJson(json['statistics'] as Map<String, dynamic>? ?? const {}),
      recentOrders: ordersJson.map((e) => UserOrderSummary.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
