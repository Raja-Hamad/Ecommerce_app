import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final _remote = CartRemoteDataSource();

  // Kept in-memory until the backend exposes get/update/remove cart endpoints;
  // addToCart is synced with the server, the rest stay local for now.
  final List<CartItem> _localCart = [];

  @override
  Future<List<CartItem>> getCartItems() async => _localCart.toList();

  @override
  Future<void> addToCart(Product product, {int quantity = 1, String? size, String? color}) async {
    await _remote.addToCart(productId: product.id, quantity: quantity);
    final index = _localCart.indexWhere((i) => i.product.id == product.id && i.size == size && i.color == color);
    if (index != -1) {
      _localCart[index].quantity += quantity;
    } else {
      _localCart.add(CartItem(product: product, quantity: quantity, size: size, color: color));
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    // TODO: sync with backend once an update-quantity endpoint is available.
    final item = _localCart.firstWhere((i) => i.product.id == productId);
    item.quantity = quantity;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    // TODO: sync with backend once a remove-item endpoint is available.
    _localCart.removeWhere((i) => i.product.id == productId);
  }

  @override
  Future<void> clearCart() async {
    _localCart.clear();
  }
}
