import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/category.dart';

class AdminCreateProductController extends GetxController {
  final _productRepo = ProductRepositoryImpl();
  final _categoryRepo = CategoryRepositoryImpl();

  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final discountPriceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final brandCtrl = TextEditingController();
  final sizeInputCtrl = TextEditingController();
  final colorInputCtrl = TextEditingController();

  final RxList<Category> categories = <Category>[].obs;
  final Rxn<Category> selectedCategory = Rxn<Category>();
  final RxBool isFeatured = false.obs;
  final RxString status = 'active'.obs;
  final RxList<String> sizes = <String>[].obs;
  final RxList<String> colors = <String>[].obs;
  final RxList<File> images = <File>[].obs;

  final RxBool isLoadingCategories = true.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    try {
      categories.value = await _categoryRepo.getCategories();
    } catch (_) {
      // Category dropdown simply stays empty; admin can retry by reopening the form.
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void setCategory(Category? category) => selectedCategory.value = category;

  void toggleFeatured(bool value) => isFeatured.value = value;

  void setStatus(String value) => status.value = value;

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

  Future<void> pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80, maxWidth: 1200);
    if (picked.isEmpty) return;
    images.addAll(picked.map((x) => File(x.path)));
  }

  void removeImage(File file) => images.remove(file);

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.value == null) {
      AppSnackbar.error('Please select a category');
      return;
    }
    if (images.isEmpty) {
      AppSnackbar.error('Please add at least one product image');
      return;
    }
    isSaving.value = true;
    try {
      final discountText = discountPriceCtrl.text.trim();
      final fields = <String, String>{
        'name': nameCtrl.text.trim(),
        'description': descriptionCtrl.text.trim(),
        'price': priceCtrl.text.trim(),
        if (discountText.isNotEmpty) 'discountPrice': discountText,
        'stock': stockCtrl.text.trim(),
        'category': selectedCategory.value!.id,
        'brand': brandCtrl.text.trim(),
        'isFeatured': isFeatured.value.toString(),
        'status': status.value,
        'sizes': sizes.join(','),
        'colors': colors.join(','),
      };
      final created = await _productRepo.createProduct(fields, images.toList());
      AppSnackbar.success('Product created successfully');
      Get.back(result: created);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to create product. Please try again.');
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
