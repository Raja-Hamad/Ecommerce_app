import '../entities/product.dart';

abstract class WishlistRepository {
  Future<List<Product>> getWishlist();
  Future<void> toggleWishlist(Product product);
  bool isInWishlist(String productId);
}
