import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';

class AdminRemoteDataSource {
  final _client = ApiClient.instance;

  Future<AdminDashboardStats> getDashboardStats() async {
    final response = await _client.get(ApiEndpoints.adminDashboard);
    return AdminDashboardStats.fromJson(response);
  }
}
