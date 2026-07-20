import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/product.dart';

class ProductRemoteDataSource {
  final _client = ApiClient.instance;

  /// Fetches products with a high page limit since the app does not yet
  /// have paginated scrolling UI; filtering/sorting happens client-side.
  Future<List<Product>> getProducts() async {
    final response = await _client.get('${ApiEndpoints.products}?limit=100');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Product> getProductById(String id) async {
    final response = await _client.get(ApiEndpoints.productById(id));
    return Product.fromJson(response['product'] as Map<String, dynamic>? ?? response);
  }

  Future<void> addReview(String productId, {required double rating, required String comment}) async {
    await _client.post(
      ApiEndpoints.addReview(productId),
      body: {'rating': rating, 'comment': comment},
    );
  }

  Future<Product> updateProduct(String id, Map<String, dynamic> fields) async {
    final response = await _client.put(ApiEndpoints.productById(id), body: fields);
    return Product.fromJson(response['product'] as Map<String, dynamic>? ?? response);
  }

  Future<Product> createProduct(Map<String, String> fields, List<File> images) async {
    final response = await _client.multipart(
      ApiEndpoints.createProduct,
      fields: fields,
      fileLists: {'images': images},
    );
    return Product.fromJson(response['product'] as Map<String, dynamic>? ?? response);
  }
}
