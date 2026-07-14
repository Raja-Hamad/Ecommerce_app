import 'package:get/get.dart';
import '../../../../data/repositories/product_repository_impl.dart';
import '../../../../domain/entities/product.dart';
import '../../../../core/routes/app_routes.dart';

enum SortOption { relevance, priceLowHigh, priceHighLow, rating }

class ProductListingController extends GetxController {
  final _repo = ProductRepositoryImpl();

  String? categoryId;
  final RxString title = 'All Products'.obs;

  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> displayed = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isGridView = true.obs;
  final Rx<SortOption> sortOption = SortOption.relevance.obs;
  final RxDouble maxPrice = 300.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      categoryId = args['categoryId'] as String?;
      if (args['categoryName'] != null) title.value = args['categoryName'] as String;
      if (args['query'] != null) title.value = 'Results for "${args['query']}"';
      fetch(query: args['query'] as String?);
    } else {
      fetch();
    }
  }

  Future<void> fetch({String? query}) async {
    isLoading.value = true;
    try {
      allProducts.value = await _repo.getProducts(categoryId: categoryId, query: query);
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void setSort(SortOption option) {
    sortOption.value = option;
    _applyFilters();
  }

  void setMaxPrice(double value) {
    maxPrice.value = value;
    _applyFilters();
  }

  void toggleView() => isGridView.value = !isGridView.value;

  void _applyFilters() {
    var list = allProducts.where((p) => p.displayPrice <= maxPrice.value).toList();
    switch (sortOption.value) {
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.displayPrice.compareTo(b.displayPrice));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.displayPrice.compareTo(a.displayPrice));
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.relevance:
        break;
    }
    displayed.value = list;
  }

  void openProduct(Product product) => Get.toNamed(AppRoutes.productDetails, arguments: product.id);
}
