import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final _remote = CartRemoteDataSource();

  // The backend doesn't yet expose a clear-cart endpoint, so we hydrate the
  // cache from the server once and keep that operation local — refetching
  // on every call would silently revert it back to the server's last
  // known state.
  List<CartItem> _cache = [];
  bool _hydrated = false;

  @override
  Future<List<CartItem>> getCartItems() async {
    if (!_hydrated) {
      _cache = await _remote.getCart();
      _hydrated = true;
    }
    return _cache.toList();
  }

  @override
  Future<void> addToCart(Product product, {int quantity = 1, String? size, String? color}) async {
    await _remote.addToCart(productId: product.id, quantity: quantity);
    // The server recalculates merged quantities, so re-sync from it.
    _cache = await _remote.getCart();
    _hydrated = true;
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    _cache = await _remote.updateQuantity(productId: productId, quantity: quantity);
    _hydrated = true;
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await _remote.removeItem(productId);
    _cache.removeWhere((i) => i.product.id == productId);
  }

  @override
  Future<void> clearCart() async {
    // TODO: sync with backend once a clear-cart endpoint is available.
    _cache.clear();
  }
}
