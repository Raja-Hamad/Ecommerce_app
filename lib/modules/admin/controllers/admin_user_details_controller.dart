import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../domain/entities/admin_user_details.dart';

class AdminUserDetailsController extends GetxController {
  final _repo = AdminRepositoryImpl();

  final Rxn<AdminUserDetails> details = Rxn<AdminUserDetails>();
  final RxBool isLoading = true.obs;

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
}
