import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqsController extends GetxController{
    var answerController = TextEditingController().obs;
  var questionController = TextEditingController().obs;
  final FirestoreServices _firestoreServices=FirestoreServices();
  RxString selectedType = ''.obs;
  var isLoading = false.obs;
  Future<void> addToCartOrWishList(
    BuildContext context,
    var model,
    String collectionName,
  ) async {
    try {
      isLoading.value = true;
      await _firestoreServices.addFaqs(
        context,
        model,
        collectionName,
      );
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error while adding product to cart is ${e.toString()}");
      }
    }
  }
}