import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final _remote = ProductRemoteDataSource();

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query}) async {
    var list = await _remote.getProducts();
    if (categoryId != null) {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final list = await _remote.getProducts();
    return list.where((p) => p.isFeatured).toList();
  }

  @override
  Future<List<Product>> getBestSellers() async {
    final list = await _remote.getProducts()
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return list.take(8).toList();
  }

  @override
  Future<Product> getProductById(String id) => _remote.getProductById(id);

  @override
  Future<void> addReview(String productId, {required double rating, required String comment}) =>
      _remote.addReview(productId, rating: rating, comment: comment);
}
