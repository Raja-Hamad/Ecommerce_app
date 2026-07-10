import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/mock_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query}) async {
    await Future.delayed(_ds.latency);
    var list = _ds.products.toList();
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
    await Future.delayed(_ds.latency);
    return _ds.products.where((p) => p.isFeatured).toList();
  }

  @override
  Future<List<Product>> getBestSellers() async {
    await Future.delayed(_ds.latency);
    final list = _ds.products.toList()..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return list.take(8).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future.delayed(_ds.latency);
    return _ds.products.firstWhere((p) => p.id == id);
  }
}
