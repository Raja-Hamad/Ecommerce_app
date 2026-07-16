import '../entities/admin_dashboard_stats.dart';
import '../entities/monthly_sales.dart';
import '../entities/recent_order.dart';
import '../entities/top_selling_product.dart';

abstract class AdminRepository {
  Future<AdminDashboardStats> getDashboardStats();
  Future<List<MonthlySales>> getMonthlySales();
  Future<List<RecentOrder>> getRecentOrders();
  Future<List<TopSellingProduct>> getTopSellingProducts();
}
