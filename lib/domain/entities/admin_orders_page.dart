import 'order.dart';

class AdminOrdersPage {
  final int currentPage;
  final int totalPages;
  final int totalOrders;
  final List<Order> orders;

  const AdminOrdersPage({
    required this.currentPage,
    required this.totalPages,
    required this.totalOrders,
    required this.orders,
  });

  bool get hasMore => currentPage < totalPages;

  factory AdminOrdersPage.fromJson(Map<String, dynamic> json) {
    final list = json['orders'] as List<dynamic>? ?? [];
    return AdminOrdersPage(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      orders: list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
