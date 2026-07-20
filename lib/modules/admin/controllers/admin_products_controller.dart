import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

class AdminProductsController extends GetxController {
  final _repo = AdminRepositoryImpl();
  final _categoryRepo = CategoryRepositoryImpl();
  final _productRepo = ProductRepositoryImpl();

  final searchCtrl = TextEditingController();
  Timer? _debounce;

  final RxList<Category> categories = <Category>[].obs;
  final Rxn<Category> selectedCategory = Rxn<Category>();
  final RxnString selectedStatus = RxnString();
  final RxnString selectedSort = RxnString();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  int _page = 1;
  int totalPages = 1;
  final RxInt totalProducts = 0.obs;

  static const statusOptions = [
    (null, 'All Status'),
    ('active', 'Active'),
    ('inactive', 'Inactive'),
  ];

  static const sortOptions = [
    (null, 'Default'),
    ('newest', 'Newest First'),
    ('oldest', 'Oldest First'),
    ('priceHigh', 'Price: High to Low'),
    ('priceLow', 'Price: Low to High'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    fetch(reset: true);
  }

  Future<void> _loadCategories() async {
    try {
      categories.value = await _categoryRepo.getCategories();
    } catch (_) {
      // Category filter simply stays empty; product listing itself still works.
    }
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => fetch(reset: true),
    );
  }

  void setCategory(Category? category) {
    selectedCategory.value = category;
    fetch(reset: true);
  }

  void setStatus(String? status) {
    selectedStatus.value = status;
    fetch(reset: true);
  }

  void setSort(String? sort) {
    selectedSort.value = sort;
    fetch(reset: true);
  }

  Future<void> fetch({bool reset = false}) async {
    if (reset) {
      _page = 1;
      isLoading.value = true;
    }
    try {
      final page = await _repo.getAllProducts(
        search: searchCtrl.text.trim(),
        // Backend matches this against Category.name, not the category _id.
        categoryName: selectedCategory.value?.name,
        status: selectedStatus.value,
        sort: selectedSort.value,
        page: _page,
      );
      totalPages = page.totalPages;
      totalProducts.value = page.totalProducts;
      products.value = reset ? page.products : [...products, ...page.products];
    } catch (e) {
      AppSnackbar.error(
        e is AppException
            ? e.message
            : 'Failed to load products. Please try again.',
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || _page >= totalPages) return;
    isLoadingMore.value = true;
    _page++;
    await fetch();
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await _productRepo.deleteProduct(product.id);
      products.remove(product);
      totalProducts.value = totalProducts.value - 1;
      AppSnackbar.success('Product deleted');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to delete product. Please try again.');
    }
  }

  Future<void> updateStatus(Product product, String newStatus) async {
    try {
      await _productRepo.updateProductStatus(product.id, newStatus);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) products[index] = product.copyWith(status: newStatus);
      AppSnackbar.success('Product status updated');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update status. Please try again.');
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }
}
