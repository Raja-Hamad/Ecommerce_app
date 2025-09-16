import 'dart:io';

import 'package:ecommerce_app_my/models/product_model.dart';
import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductController extends GetxController {
  var productTitleController = TextEditingController().obs;
  var productSubtitleController = TextEditingController().obs;
  var productPriceController = TextEditingController().obs;
  var productDexcriptionController = TextEditingController().obs;
  var productSizesController = TextEditingController().obs;
  var availableProductStock = TextEditingController().obs;
  var selectedCategory = ''.obs;
  var selectedImages = <File>[].obs; // 👈 multiple images
  var isLoading = false.obs;
  var productListViewController = TextEditingController().obs;
  final FirestoreServices _firestoreServices = FirestoreServices();
  Future<void> pickImagesFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(); // 👈 multiple image picker
    if (picked.isNotEmpty) {
      selectedImages.value = picked.map((e) => File(e.path)).toList();
    }
  }

  Future<void> addProduct({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String price,
    required String description,
    required String productSizes,
    required String totalStock,
    required String category,
  }) async {
    try {
      isLoading.value = true;
      List<String> uploadedUrls = [];

      for (var img in selectedImages) {
        String url = await _firestoreServices.uploadImageToCloudinary(
          img,
          context,
        );
        uploadedUrls.add(url);
      }
      ProductModel model = ProductModel(
        category: category,
        adminId: FirebaseAuth.instance.currentUser!.uid,
        description: description,
        id: Uuid().v4(),
        imageUrls: uploadedUrls,
        price: int.parse(price),
        sizes: productSizes,
        stock: totalStock,
        subtitle: subtitle,
        title: title,
      );
      // ignore: use_build_context_synchronously
      await _firestoreServices.addProduct(context, model);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error while adding product is ${e.toString()}");
      }
    }
  }
}
