import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../../../domain/entities/admin_products_page.dart';
import '../../../domain/entities/monthly_sales.dart';
import '../../../domain/entities/recent_order.dart';
import '../../../domain/entities/recent_user.dart';
import '../../../domain/entities/top_selling_product.dart';

class AdminRemoteDataSource {
  final _client = ApiClient.instance;

  Future<AdminDashboardStats> getDashboardStats() async {
    final response = await _client.get(ApiEndpoints.adminDashboard);
    return AdminDashboardStats.fromJson(response);
  }

  Future<List<MonthlySales>> getMonthlySales() async {
    final response = await _client.get(ApiEndpoints.adminMonthlySales);
    final list = response['data'] as List<dynamic>? ?? [];
    return list.map((e) => MonthlySales.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RecentOrder>> getRecentOrders() async {
    final response = await _client.get(ApiEndpoints.adminRecentOrders);
    final list = response['orders'] as List<dynamic>? ?? [];
    return list.map((e) => RecentOrder.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<TopSellingProduct>> getTopSellingProducts() async {
    final response = await _client.get(ApiEndpoints.adminTopSellingProducts);
    final list = response['products'] as List<dynamic>? ?? [];
    return list.map((e) => TopSellingProduct.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RecentUser>> getRecentUsers() async {
    final response = await _client.get(ApiEndpoints.adminRecentUsers);
    final list = response['users'] as List<dynamic>? ?? [];
    return list.map((e) => RecentUser.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AdminProductsPage> getAllProducts({
    String? search,
    String? categoryName,
    String? status,
    String? sort,
    int page = 1,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryName != null && categoryName.isNotEmpty) 'category': categoryName,
      if (status != null && status.isNotEmpty) 'status': status,
      if (sort != null && sort.isNotEmpty) 'sort': sort,
    };
    final response = await _client.get(ApiEndpoints.adminAllProducts, query: query);
    return AdminProductsPage.fromJson(response);
  }
}
