import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/entities/category.dart';

class AdminEditCategoryController extends GetxController {
  final _repo = CategoryRepositoryImpl();

  late final Category category;
  final formKey = GlobalKey<FormState>();

  late final nameCtrl = TextEditingController(text: category.name);
  late final descriptionCtrl = TextEditingController(text: category.description);

  final Rxn<File> newImage = Rxn<File>();
  final RxBool isSaving = false.obs;

  AdminEditCategoryController() {
    category = Get.arguments as Category;
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (picked != null) newImage.value = File(picked.path);
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final updated = await _repo.updateCategory(
        category.id,
        name: nameCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
        image: newImage.value,
      );
      AppSnackbar.success('Category updated successfully');
      Get.back(result: updated);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update category. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
