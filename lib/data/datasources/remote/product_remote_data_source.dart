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
    return Product.fromJson(response);
  }

  Future<void> addReview(String productId, {required double rating, required String comment}) async {
    await _client.post(
      ApiEndpoints.addReview(productId),
      body: {'rating': rating, 'comment': comment},
    );
  }
}
