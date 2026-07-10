import 'cart_item.dart';
import 'address.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentStatus { pending, paid, failed }

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.address,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.couponCode,
  });

  final String id;
  final List<CartItem> items;
  final Address address;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final String? couponCode;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
