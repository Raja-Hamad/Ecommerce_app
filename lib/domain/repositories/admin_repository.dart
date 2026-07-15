import '../entities/admin_dashboard_stats.dart';

abstract class AdminRepository {
  Future<AdminDashboardStats> getDashboardStats();
}
