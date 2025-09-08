import 'dart:io';

import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/successfully_signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_services.dart';

class SignupController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var confirmPasswordController=TextEditingController().obs;

  var profileImagePath = "".obs;
  void disposeValues() {
   
    nameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
   
    profileImagePath.value = '';
  }


  var selectedImage = Rxn<File>();

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> registerAdmin({
    required String name,
    required String email,
    required String password,

    required File? image,
    required BuildContext context,
  }) async {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$',
    );
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!passwordRegex.hasMatch(password)) {
      FlushBarMessages.errorMessageFlushBar(
        "Password must be at least 8 characters and include a letter, number, and special character.",
        context,
      );
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      FlushBarMessages.errorMessageFlushBar(
        "Please enter a valid email address.",
        context,
      );
      return;
    }

    if (password.isEmpty ||
        email.isEmpty ||
        name.isEmpty ||
        image == null) {
      FlushBarMessages.errorMessageFlushBar(
        "Please fill all the fields",
        context,
      );
      return;
    }

    isLoading.value = true;

    // ✅ Pehle check karo ke email already exist to nahi karti
    final emailExists = await _authServices.checkIfEmailExists(email);
    if (emailExists) {
      isLoading.value = false;
      FlushBarMessages.errorMessageFlushBar(
        "This email is already registered.",
        // ignore: use_build_context_synchronously
        context,
      );
      return;
    }

    // ✅ Ab sirf tab image upload karo jab email unique ho
    String? imageUrl;
    if (image != null) {
      imageUrl = await _firestoreServices.uploadImageToCloudinary(
        image,
        // ignore: use_build_context_synchronously
        context,
      );
    }

    final error = await _authServices.registerAdmin(
      name,
      email,
      password,
    
      imageUrl ?? ""
    
    );

    isLoading.value = false;

    if (error == null) {
      FlushBarMessages.successMessageFlushBar(
        "Registered Successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      disposeValues();
      Get.offAll(SuccessfullySignupView());
    } else {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar(error.toString(), context);
      errorMessage.value = error;
    }
  }
}
