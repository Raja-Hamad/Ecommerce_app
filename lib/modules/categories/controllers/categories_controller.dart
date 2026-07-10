import 'package:get/get.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/entities/category.dart';
import '../../../core/routes/app_routes.dart';

class CategoriesController extends GetxController {
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
    } finally {
      isLoading.value = false;
    }
  }

  void openCategory(Category category) {
    Get.toNamed(AppRoutes.productListing, arguments: {'categoryId': category.id, 'categoryName': category.name});
  }
}
