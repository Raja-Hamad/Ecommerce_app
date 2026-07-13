import '../../domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/remote/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final _remote = WishlistRemoteDataSource();

  List<Product> _cache = [];
  bool _hydrated = false;

  @override
  Future<List<Product>> getWishlist() async {
    if (!_hydrated) {
      _cache = await _remote.getWishlist();
      _hydrated = true;
    }
    return _cache.toList();
  }

  @override
  Future<void> toggleWishlist(Product product) async {
    if (!_hydrated) {
      _cache = await _remote.getWishlist();
      _hydrated = true;
    }
    if (_cache.any((p) => p.id == product.id)) {
      await _remote.removeFromWishlist(product.id);
      _cache.removeWhere((p) => p.id == product.id);
    } else {
      await _remote.addToWishlist(product.id);
      _cache.add(product);
    }
  }

  @override
  bool isInWishlist(String productId) => _cache.any((p) => p.id == productId);
}
