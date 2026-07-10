import '../entities/cart_item.dart';
import '../entities/product.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(Product product, {int quantity = 1, String? size, String? color});
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
}
