import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

class AdminEditProductController extends GetxController {
  final _productRepo = ProductRepositoryImpl();
  final _categoryRepo = CategoryRepositoryImpl();

  late final Product product;
  final formKey = GlobalKey<FormState>();

  late final nameCtrl = TextEditingController(text: product.name);
  late final descriptionCtrl = TextEditingController(text: product.description);
  late final priceCtrl = TextEditingController(text: product.price == 0 ? '' : product.price.toStringAsFixed(0));
  late final discountPriceCtrl = TextEditingController(text: product.discountPrice == null ? '' : product.discountPrice!.toStringAsFixed(0));
  late final stockCtrl = TextEditingController(text: '${product.stock}');
  late final brandCtrl = TextEditingController(text: product.brand);
  final sizeInputCtrl = TextEditingController();
  final colorInputCtrl = TextEditingController();

  final RxList<Category> categories = <Category>[].obs;
  final Rxn<Category> selectedCategory = Rxn<Category>();
  final RxBool isFeatured = false.obs;
  late final RxList<String> sizes;
  late final RxList<String> colors;

  final RxBool isLoadingCategories = true.obs;
  final RxBool isSaving = false.obs;

  AdminEditProductController() {
    product = Get.arguments as Product;
    isFeatured.value = product.isFeatured;
    sizes = <String>[...product.sizes].obs;
    colors = <String>[...product.colors].obs;
  }

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    try {
      categories.value = await _categoryRepo.getCategories();
      selectedCategory.value = categories.firstWhereOrNull((c) => c.id == product.categoryId);
    } catch (_) {
      // Category dropdown simply stays empty; other fields can still be edited.
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void setCategory(Category? category) => selectedCategory.value = category;

  void toggleFeatured(bool value) => isFeatured.value = value;

  void addSize() {
    final value = sizeInputCtrl.text.trim();
    if (value.isEmpty || sizes.contains(value)) return;
    sizes.add(value);
    sizeInputCtrl.clear();
  }

  void removeSize(String size) => sizes.remove(size);

  void addColor() {
    final value = colorInputCtrl.text.trim();
    if (value.isEmpty || colors.contains(value)) return;
    colors.add(value);
    colorInputCtrl.clear();
  }

  void removeColor(String color) => colors.remove(color);

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.value == null) {
      AppSnackbar.error('Please select a category');
      return;
    }
    isSaving.value = true;
    try {
      final discountText = discountPriceCtrl.text.trim();
      final fields = <String, dynamic>{
        'name': nameCtrl.text.trim(),
        'description': descriptionCtrl.text.trim(),
        'price': double.tryParse(priceCtrl.text.trim()) ?? 0,
        'discountPrice': discountText.isEmpty ? null : double.tryParse(discountText),
        'stock': int.tryParse(stockCtrl.text.trim()) ?? 0,
        'category': selectedCategory.value!.id,
        'brand': brandCtrl.text.trim(),
        'isFeatured': isFeatured.value,
        'sizes': sizes,
        'colors': colors,
      };
      final updated = await _productRepo.updateProduct(product.id, fields);
      AppSnackbar.success('Product updated successfully');
      Get.back(result: updated);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update product. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    priceCtrl.dispose();
    discountPriceCtrl.dispose();
    stockCtrl.dispose();
    brandCtrl.dispose();
    sizeInputCtrl.dispose();
    colorInputCtrl.dispose();
    super.onClose();
  }
}
