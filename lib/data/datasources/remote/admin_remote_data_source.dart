import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../../../domain/entities/monthly_sales.dart';

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
}
