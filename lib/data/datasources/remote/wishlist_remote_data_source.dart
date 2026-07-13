import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/product.dart';

class WishlistRemoteDataSource {
  final _client = ApiClient.instance;

  Future<List<Product>> getWishlist() async {
    final response = await _client.get(ApiEndpoints.wishlist);
    final data = response['products'] as List<dynamic>? ?? [];
    return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addToWishlist(String productId) async {
    await _client.post(ApiEndpoints.addToWishlist(productId));
  }

  Future<void> removeFromWishlist(String productId) async {
    await _client.delete(ApiEndpoints.removeFromWishlist(productId));
  }
}
