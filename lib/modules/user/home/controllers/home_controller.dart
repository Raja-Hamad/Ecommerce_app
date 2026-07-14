import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/category_repository_impl.dart';
import '../../../../data/repositories/product_repository_impl.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/product.dart';
import '../../../../core/routes/app_routes.dart';

class HomeController extends GetxController {
  final _productRepo = ProductRepositoryImpl();
  final _categoryRepo = CategoryRepositoryImpl();

  final TextEditingController searchCtrl = TextEditingController();

  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> featured = <Product>[].obs;
  final RxList<Product> bestSellers = <Product>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _categoryRepo.getCategories(),
        _productRepo.getFeaturedProducts(),
        _productRepo.getBestSellers(),
      ]);
      categories.value = results[0] as List<Category>;
      featured.value = results[1] as List<Product>;
      bestSellers.value = results[2] as List<Product>;
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    Get.toNamed(AppRoutes.productListing, arguments: {'query': query.trim()});
  }

  void openCategory(Category category) {
    Get.toNamed(AppRoutes.productListing, arguments: {'categoryId': category.id, 'categoryName': category.name});
  }

  void openProduct(Product product) {
    Get.toNamed(AppRoutes.productDetails, arguments: product.id);
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
