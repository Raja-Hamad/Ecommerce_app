import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String? categoryId, String? query});
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getBestSellers();
  Future<Product> getProductById(String id);
}
