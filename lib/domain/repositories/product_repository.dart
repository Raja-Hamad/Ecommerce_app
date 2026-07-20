import 'dart:io';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String? categoryId, String? query});
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getBestSellers();
  Future<Product> getProductById(String id);
  Future<void> addReview(String productId, {required double rating, required String comment});
  Future<Product> updateProduct(String id, Map<String, dynamic> fields);
  Future<Product> createProduct(Map<String, String> fields, List<File> images);
}
