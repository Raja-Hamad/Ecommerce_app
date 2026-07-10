import 'package:get/get.dart';
import '../../../data/repositories/coupon_repository_impl.dart';
import '../../../domain/entities/coupon.dart';

class CouponController extends GetxController {
  final _repo = CouponRepositoryImpl();

  final double orderValue;
  CouponController({required this.orderValue});

  final RxList<Coupon> coupons = <Coupon>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      coupons.value = await _repo.getAvailableCoupons();
    } finally {
      isLoading.value = false;
    }
  }

  bool isEligible(Coupon coupon) => orderValue >= coupon.minOrderValue;
}
