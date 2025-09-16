import 'package:ecommerce_app_my/views/my_orders_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'views/onboarding_view.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Yahan tum background me koi processing kar sakte ho agar chaho
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// 1️⃣ App killed state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    /// 2️⃣ App background state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    /// 3️⃣ Foreground notification listener (optional)
    FirebaseMessaging.onMessage.listen((message) {
      // Tum yahan local notification dikhane ka kaam kar sakte ho
      debugPrint("Foreground message: ${message.data}");
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Check karo notification ka type ya screen key
    if (message.data['screen'] == 'orders') {
      Get.to(() => const MyOrdersView());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(NetworkController()); // Start network listener

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: OnboardingView(),
      // getPages: [
      //   GetPage(name: '/NoInternetScreen', page: () => NoInternetView()),
      // ],
    );
  }
}
