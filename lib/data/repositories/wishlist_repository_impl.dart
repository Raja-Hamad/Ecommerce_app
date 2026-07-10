import '../../domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/mock_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Product>> getWishlist() async {
    await Future.delayed(_ds.latency);
    return _ds.products.where((p) => _ds.wishlistIds.contains(p.id)).toList();
  }

  @override
  Future<void> toggleWishlist(Product product) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_ds.wishlistIds.contains(product.id)) {
      _ds.wishlistIds.remove(product.id);
    } else {
      _ds.wishlistIds.add(product.id);
    }
  }

  @override
  bool isInWishlist(String productId) => _ds.wishlistIds.contains(productId);
}
