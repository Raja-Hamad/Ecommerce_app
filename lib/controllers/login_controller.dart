import 'package:ecommerce_app_my/services/auth_services.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthServices _authServices = AuthServices();
  List<String> adminEmails = [
    "admin1@gmail.com",
    "admin2@gmail.com",
    "admin3@gmail.com",
    "admin4@gmail.com",
  ];

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  Future<void> loginAdmin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    email = email.trim();
    password = password.trim();

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (email.isEmpty || password.isEmpty) {
      FlushBarMessages.errorMessageFlushBar(
        "Email and password are required.",
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

    isLoading.value = true;

    // 🧑 Regular user login
    final error = await _authServices.loginUser(email, password, context);
    isLoading.value = false;

    if (error == null) {
      // ignore: use_build_context_synchronously
      FlushBarMessages.successMessageFlushBar("Login Successfully", context);
    } else {
      errorMessage.value = error;

      final isInvalidLogin =
          error.toLowerCase().contains("password is invalid") ||
          error.toLowerCase().contains("no user record");

      FlushBarMessages.errorMessageFlushBar(
        isInvalidLogin
            ? "Invalid email or password. Please try again."
            : error.toString(),
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }
}
