import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class CartRemoteDataSource {
  final _client = ApiClient.instance;

  Future<void> addToCart({required String productId, required int quantity}) async {
    await _client.post(
      ApiEndpoints.addToCart,
      body: {'productId': productId, 'quantity': quantity},
    );
  }
}
