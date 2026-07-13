import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/coupon.dart';

class CouponRemoteDataSource {
  final _client = ApiClient.instance;

  Future<List<Coupon>> getCoupons() async {
    final response = await _client.get('${ApiEndpoints.coupons}?limit=100');
    final data = response['coupons'] as List<dynamic>? ?? [];
    return data.map((json) => Coupon.fromJson(json as Map<String, dynamic>)).toList();
  }
}
