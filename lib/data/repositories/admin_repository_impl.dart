import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/monthly_sales.dart';
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
}
