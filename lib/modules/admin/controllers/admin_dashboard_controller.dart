import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../domain/entities/admin_dashboard_stats.dart';
import '../../../domain/entities/monthly_sales.dart';

class AdminDashboardController extends GetxController {
  final _repo = AdminRepositoryImpl();

  final Rxn<AdminDashboardStats> stats = Rxn<AdminDashboardStats>();
  final RxList<MonthlySales> monthlySales = <MonthlySales>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([_repo.getDashboardStats(), _repo.getMonthlySales()]);
      stats.value = results[0] as AdminDashboardStats;
      monthlySales.value = results[1] as List<MonthlySales>;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load dashboard. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
