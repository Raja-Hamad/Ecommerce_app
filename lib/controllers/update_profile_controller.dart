import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:ecommerce_app_my/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  var textEditingControllerEmail = TextEditingController().obs;
  var textEditingControllerName = TextEditingController().obs;

  final FirestoreServices _firestoreServices = FirestoreServices();

  var isLoading = false.obs;
  var selectedImage = Rxn<File>();

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> updateProfile(
    String newEmail,
    String newName,
  
  String imageUrl,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Get.snackbar("Error", "User not logged in.");
        return;
      }

      // Re-authenticate the user if needed (this depends on your app flow)

      // 🔄 Step 1: Update email in Firebase Authentication
      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
      }
    

      // ✅ Step 2: Update Firestore user info
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
            'email': newEmail,
            'userName': newName,
          
            'imageUrl': imageUrl,
          });

    
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
