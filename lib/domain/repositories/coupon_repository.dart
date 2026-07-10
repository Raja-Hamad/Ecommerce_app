import '../entities/coupon.dart';

abstract class CouponRepository {
  Future<List<Coupon>> getAvailableCoupons();
  Future<Coupon?> validateCoupon(String code, double orderValue);
}
