import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/admin_products_page.dart';
import '../../domain/entities/admin_user_details.dart';
import '../../domain/entities/admin_users_page.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/recent_order.dart';
import '../../domain/entities/recent_user.dart';
import '../../domain/entities/top_selling_product.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/remote/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final _remote = AdminRemoteDataSource();

  @override
  Future<AdminDashboardStats> getDashboardStats() {
    return _remote.getDashboardStats();
  }

  @override
  Future<List<MonthlySales>> getMonthlySales() {
    return _remote.getMonthlySales();
  }

  @override
  Future<List<RecentOrder>> getRecentOrders() {
    return _remote.getRecentOrders();
  }

  @override
  Future<List<TopSellingProduct>> getTopSellingProducts() {
    return _remote.getTopSellingProducts();
  }

  @override
  Future<List<RecentUser>> getRecentUsers() {
    return _remote.getRecentUsers();
  }

  @override
  Future<AdminProductsPage> getAllProducts({String? search, String? categoryName, String? status, String? sort, int page = 1}) {
    return _remote.getAllProducts(search: search, categoryName: categoryName, status: status, sort: sort, page: page);
  }

  @override
  Future<List<Product>> getLowStockProducts() {
    return _remote.getLowStockProducts();
  }

  @override
  Future<List<Product>> getOutOfStockProducts() {
    return _remote.getOutOfStockProducts();
  }

  @override
  Future<AdminUsersPage> getAllUsers({String? search, String? status, String? sort, int page = 1}) {
    return _remote.getAllUsers(search: search, status: status, sort: sort, page: page);
  }

  @override
  Future<AdminUserDetails> getUserDetails(String userId) {
    return _remote.getUserDetails(userId);
  }

  @override
  Future<void> updateUserStatus(String userId, String status) {
    return _remote.updateUserStatus(userId, status);
  }
}
