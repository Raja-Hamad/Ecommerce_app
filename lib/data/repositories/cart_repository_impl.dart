import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/mock_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(_ds.latency);
    return _ds.cart
        .map((entry) => CartItem(
              product: _ds.products.firstWhere((p) => p.id == entry.productId),
              quantity: entry.quantity,
              size: entry.size,
              color: entry.color,
            ))
        .toList();
  }

  @override
  Future<void> addToCart(Product product, {int quantity = 1, String? size, String? color}) async {
    await Future.delayed(_ds.latency);
    final existing = _ds.cart.where((e) => e.productId == product.id && e.size == size && e.color == color);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _ds.cart.add(CartEntry(productId: product.id, quantity: quantity, size: size, color: color));
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    await Future.delayed(_ds.latency);
    final entry = _ds.cart.firstWhere((e) => e.productId == productId);
    entry.quantity = quantity;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await Future.delayed(_ds.latency);
    _ds.cart.removeWhere((e) => e.productId == productId);
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(_ds.latency);
    _ds.cart.clear();
  }
}
