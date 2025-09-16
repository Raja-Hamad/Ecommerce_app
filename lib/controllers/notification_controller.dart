import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{

  final FirestoreServices _firestoreServices=FirestoreServices();
  var isLoading = false.obs;
  Future<void> addFaqOrOrders(
    BuildContext context,
    var model,
    String collectionName,
  ) async {
    try {
      isLoading.value = true;
      await _firestoreServices.addFaqsOrOrders(
        context,
        model,
        collectionName,
      );
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error while adding notification is ${e.toString()}");
      }
    }
  }
}