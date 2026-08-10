import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/category_repository_impl.dart';

class AdminCreateCategoryController extends GetxController {
  final _repo = CategoryRepositoryImpl();

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final Rxn<File> image = Rxn<File>();
  final RxBool isSaving = false.obs;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (picked != null) image.value = File(picked.path);
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    if (image.value == null) {
      AppSnackbar.error('Please select a category image');
      return;
    }
    isSaving.value = true;
    try {
      final created = await _repo.createCategory(
        name: nameCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
        image: image.value!,
      );
      AppSnackbar.success('Category created successfully');
      Get.back(result: created);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to create category. Please try again.');
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
