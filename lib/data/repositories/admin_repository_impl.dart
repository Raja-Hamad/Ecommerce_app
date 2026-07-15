import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/remote/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final _remote = AdminRemoteDataSource();

  @override
  Future<AdminDashboardStats> getDashboardStats() {
    return _remote.getDashboardStats();
  }
}
