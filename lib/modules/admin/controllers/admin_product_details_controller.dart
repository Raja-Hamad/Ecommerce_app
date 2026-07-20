import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

class AdminProductDetailsController extends GetxController {
  final _repo = ProductRepositoryImpl();
  final _categoryRepo = CategoryRepositoryImpl();

  final Rxn<Product> product = Rxn<Product>();
  final RxBool isLoading = true.obs;
  final RxBool isDeleting = false.obs;
  final RxInt selectedImage = 0.obs;
  List<Category> _categories = [];

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String;
    fetch(id);
  }

  String get categoryName {
    final id = product.value?.categoryId;
    if (id == null || id.isEmpty) return '';
    return _categories.firstWhereOrNull((c) => c.id == id)?.name ?? '';
  }

  Future<void> fetch(String id) async {
    isLoading.value = true;
    try {
      final results = await Future.wait([_repo.getProductById(id), _categoryRepo.getCategories()]);
      product.value = results[0] as Product;
      _categories = results[1] as List<Category>;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load product. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct() async {
    if (product.value == null) return false;
    isDeleting.value = true;
    try {
      await _repo.deleteProduct(product.value!.id);
      AppSnackbar.success('Product deleted');
      return true;
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to delete product. Please try again.');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}
