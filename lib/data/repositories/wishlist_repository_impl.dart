import '../../domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  // Kept in-memory until a backend wishlist API is available.
  final List<Product> _localWishlist = [];

  @override
  Future<List<Product>> getWishlist() async => _localWishlist.toList();

  @override
  Future<void> toggleWishlist(Product product) async {
    final index = _localWishlist.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _localWishlist.removeAt(index);
    } else {
      _localWishlist.add(product);
    }
  }

  @override
  bool isInWishlist(String productId) => _localWishlist.any((p) => p.id == productId);
}
