import 'package:get/get.dart';

class RootController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      currentIndex.value = args['tab'] as int;
    }
  }

  void changeTab(int index) => currentIndex.value = index;
}
