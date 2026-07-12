import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/product.dart';

class CartRemoteDataSource {
  final _client = ApiClient.instance;

  Future<void> addToCart({required String productId, required int quantity}) async {
    await _client.post(
      ApiEndpoints.addToCart,
      body: {'productId': productId, 'quantity': quantity},
    );
  }

  Future<void> removeItem(String productId) async {
    await _client.delete(ApiEndpoints.removeCartItem(productId));
  }

  Future<List<CartItem>> getCart() async {
    final response = await _client.get(ApiEndpoints.getCart);
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) {
      final map = json as Map<String, dynamic>;
      return CartItem(
        product: Product.fromJson(map['product'] as Map<String, dynamic>),
        quantity: map['quantity'] as int? ?? 1,
      );
    }).toList();
  }
}
