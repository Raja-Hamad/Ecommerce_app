import 'address.dart';
import 'product.dart';

enum PaymentMethod { stripe, cod }

extension PaymentMethodApi on PaymentMethod {
  String get apiValue => this == PaymentMethod.stripe ? 'STRIPE' : 'COD';

  static PaymentMethod fromApi(String? value) => value == 'COD' ? PaymentMethod.cod : PaymentMethod.stripe;
}

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

enum PaymentStatus { pending, paid, failed }

OrderStatus _parseOrderStatus(String? value) {
  switch (value) {
    case 'confirmed':
      return OrderStatus.confirmed;
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
  const OrderLineItem({required this.productId, required this.quantity, required this.price, this.product});

  final String productId;
  final int quantity;
  final double price;
  // Populated by the "my orders" list endpoint; null right after placing an
  // order, where the backend only echoes back the product id.
  final Product? product;

  double get subtotal => price * quantity;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    Product? product;
    String productId;
    if (productJson is Map<String, dynamic>) {
      productId = (productJson['_id'] ?? '').toString();
      if (productJson.containsKey('name')) {
        product = Product.fromJson(productJson);
      }
    } else {
      productId = (productJson ?? '').toString();
    }
    return OrderLineItem(
      productId: productId,
      product: product,
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
    this.customerName,
    this.customerEmail,
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
  // Only populated by admin-facing endpoints, which embed the customer.
  final String? customerName;
  final String? customerEmail;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isCancellable => status == OrderStatus.pending || status == OrderStatus.confirmed;

  factory Order.fromJson(Map<String, dynamic> json) {
    final totalAmount = (json['totalAmount'] as num?)?.toDouble() ?? 0;
    final user = json['user'];
    return Order(
      id: (json['orderId'] ?? json['_id'] ?? json['id'] ?? '').toString(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: Address.fromJson(json['shippingAddress'] as Map<String, dynamic>? ?? const {}),
      totalAmount: totalAmount,
      paymentMethod: PaymentMethodApi.fromApi(json['paymentMethod'] as String?),
      paymentStatus: _parsePaymentStatus(json['paymentStatus'] as String?),
      status: _parseOrderStatus(json['status'] as String?),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      // The "my orders" list doesn't echo finalAmount when no coupon was
      // used, so fall back to totalAmount.
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? totalAmount,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      couponCode: json['coupon'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      customerName: user is Map<String, dynamic> ? user['name'] as String? : null,
      customerEmail: user is Map<String, dynamic> ? user['email'] as String? : null,
    );
  }
}
