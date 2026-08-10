import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/entities/category.dart';

class AdminCategoriesController extends GetxController {
  final _repo = CategoryRepositoryImpl();

  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      categories.value = await _repo.getCategories();
    } catch (e) {
      AppSnackbar.error(
        e is AppException
            ? e.message
            : 'Failed to load categories. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // admin_categories_controller.dart

  Future<bool> deleteCategory(Category category) async {
    try {
      await _repo.deleteCategory(category.id);
      categories.remove(category);
      AppSnackbar.success('Category deleted');
      return true; // ✅ Return true on success
    } catch (e) {
      AppSnackbar.error(
        e is AppException
            ? e.message
            : 'Failed to delete category. Please try again.',
      );
      return false; // ✅ Return false on error
    }
  }
}
