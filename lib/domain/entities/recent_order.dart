class RecentOrder {
  final String orderId;
  final String customerName;
  final double totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;

  const RecentOrder({
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      orderId: json['orderId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? 'Unknown',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      orderStatus: json['orderStatus'] as String? ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
