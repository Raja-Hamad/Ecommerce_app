import 'dart:async';

import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/admin_bottom_nav_bar.dart';
import 'package:ecommerce_app_my/views/bottom_nav_bar.dart';
import 'package:ecommerce_app_my/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  final LocalStorage _localStorage = LocalStorage();

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // optional splash delay
    String? userId = await _localStorage.getValue("id");
    String? userEmail = await _localStorage.getValue("email");

    if (userId != null && userEmail != null) {
      if (userEmail == "kayanihamad0316@gmail.com") {
        Get.offAll(() => AdminBottomNavBar());
      } else {
        Get.offAll(BottomNavBarView());
      }
    } else {
      Get.offAll(() => SplashView());
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ Cancel timer to avoid callback after dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          "assets/images/ecommerce_splash_logo.png",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
