import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/config/stripe_config.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // flutter_stripe's web implementation reaches into dart:io Platform
  // (Platform.isIOS), which throws on web. Payments aren't reachable there
  // yet, so just skip Stripe setup on web instead of crashing at startup.
  if (!kIsWeb) {
    Stripe.publishableKey = StripeConfig.publishableKey;
    await Stripe.instance.applySettings();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
