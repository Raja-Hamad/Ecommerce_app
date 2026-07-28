import '../entities/admin_dashboard_stats.dart';
import '../entities/admin_products_page.dart';
import '../entities/admin_user_details.dart';
import '../entities/admin_users_page.dart';
import '../entities/monthly_sales.dart';
import '../entities/product.dart';
import '../entities/recent_order.dart';
import '../entities/recent_user.dart';
import '../entities/top_selling_product.dart';

abstract class AdminRepository {
  Future<AdminDashboardStats> getDashboardStats();
  Future<List<MonthlySales>> getMonthlySales();
  Future<List<RecentOrder>> getRecentOrders();
  Future<List<TopSellingProduct>> getTopSellingProducts();
  Future<List<RecentUser>> getRecentUsers();
  Future<AdminProductsPage> getAllProducts({String? search, String? categoryName, String? status, String? sort, int page = 1});
  Future<List<Product>> getLowStockProducts();
  Future<List<Product>> getOutOfStockProducts();
  Future<AdminUsersPage> getAllUsers({String? search, String? status, String? sort, int page = 1});
  Future<AdminUserDetails> getUserDetails(String userId);
}
