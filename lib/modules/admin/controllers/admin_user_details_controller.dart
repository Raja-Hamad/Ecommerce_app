import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../domain/entities/admin_user_details.dart';

class AdminUserDetailsController extends GetxController {
  final _repo = AdminRepositoryImpl();

  final Rxn<AdminUserDetails> details = Rxn<AdminUserDetails>();
  final RxBool isLoading = true.obs;
  final RxBool isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch(Get.arguments as String);
  }

  Future<void> fetch(String userId) async {
    isLoading.value = true;
    try {
      details.value = await _repo.getUserDetails(userId);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load user. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String newStatus) async {
    final current = details.value;
    if (current == null) return;
    isUpdatingStatus.value = true;
    try {
      await _repo.updateUserStatus(current.user.id, newStatus);
      details.value = current.copyWith(user: current.user.copyWith(status: newStatus));
      AppSnackbar.success('User status updated');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update status. Please try again.');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
