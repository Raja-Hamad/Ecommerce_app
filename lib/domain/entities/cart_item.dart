import 'product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1, this.size, this.color});

  final Product product;
  int quantity;
  final String? size;
  final String? color;

  double get subtotal => product.displayPrice * quantity;
}
