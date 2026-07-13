import 'address.dart';

enum PaymentMethod { stripe, cod }

extension PaymentMethodApi on PaymentMethod {
  String get apiValue => this == PaymentMethod.stripe ? 'STRIPE' : 'COD';

  static PaymentMethod fromApi(String? value) => value == 'COD' ? PaymentMethod.cod : PaymentMethod.stripe;
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentStatus { pending, paid, failed }

OrderStatus _parseOrderStatus(String? value) {
  switch (value) {
    case 'processing':
      return OrderStatus.processing;
    case 'shipped':
      return OrderStatus.shipped;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.pending;
  }
}

PaymentStatus _parsePaymentStatus(String? value) {
  switch (value) {
    case 'paid':
      return PaymentStatus.paid;
    case 'failed':
      return PaymentStatus.failed;
    default:
      return PaymentStatus.pending;
  }
}

class OrderLineItem {
  const OrderLineItem({required this.productId, required this.quantity, required this.price});

  final String productId;
  final int quantity;
  final double price;

  double get subtotal => price * quantity;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return OrderLineItem(
      productId: product is Map<String, dynamic> ? (product['_id'] ?? '').toString() : (product ?? '').toString(),
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.discount,
    required this.finalAmount,
    required this.createdAt,
    this.couponCode,
    this.stripePaymentIntentId,
  });

  final String id;
  final List<OrderLineItem> items;
  final Address shippingAddress;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus status;
  final double discount;
  final double finalAmount;
  final DateTime createdAt;
  final String? couponCode;
  final String? stripePaymentIntentId;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: Address.fromJson(json['shippingAddress'] as Map<String, dynamic>? ?? const {}),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paymentMethod: PaymentMethodApi.fromApi(json['paymentMethod'] as String?),
      paymentStatus: _parsePaymentStatus(json['paymentStatus'] as String?),
      status: _parseOrderStatus(json['status'] as String?),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      couponCode: json['coupon'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
    );
  }
}
