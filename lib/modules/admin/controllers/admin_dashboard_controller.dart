import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../../../domain/entities/monthly_sales.dart';
import '../../../domain/entities/recent_order.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/recent_user.dart';
import '../../../domain/entities/top_selling_product.dart';

class AdminDashboardController extends GetxController {
  final _repo = AdminRepositoryImpl();

  final Rxn<AdminDashboardStats> stats = Rxn<AdminDashboardStats>();
  final RxList<MonthlySales> monthlySales = <MonthlySales>[].obs;
  final RxList<RecentOrder> recentOrders = <RecentOrder>[].obs;
  final RxList<TopSellingProduct> topSellingProducts = <TopSellingProduct>[].obs;
  final RxList<RecentUser> recentUsers = <RecentUser>[].obs;
  final RxList<Product> lowStockProducts = <Product>[].obs;
  final RxList<Product> outOfStockProducts = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt inventoryTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  void setInventoryTab(int index) => inventoryTab.value = index;

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repo.getDashboardStats(),
        _repo.getMonthlySales(),
        _repo.getRecentOrders(),
        _repo.getTopSellingProducts(),
        _repo.getRecentUsers(),
        _repo.getLowStockProducts(),
        _repo.getOutOfStockProducts(),
      ]);
      stats.value = results[0] as AdminDashboardStats;
      monthlySales.value = results[1] as List<MonthlySales>;
      recentOrders.value = results[2] as List<RecentOrder>;
      topSellingProducts.value = results[3] as List<TopSellingProduct>;
      recentUsers.value = results[4] as List<RecentUser>;
      lowStockProducts.value = results[5] as List<Product>;
      outOfStockProducts.value = results[6] as List<Product>;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load dashboard. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
