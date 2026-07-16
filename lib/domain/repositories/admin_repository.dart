import '../entities/admin_dashboard_stats.dart';
import '../entities/monthly_sales.dart';

abstract class AdminRepository {
  Future<AdminDashboardStats> getDashboardStats();
  Future<List<MonthlySales>> getMonthlySales();
}
