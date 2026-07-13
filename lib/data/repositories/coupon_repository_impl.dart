import '../../domain/entities/coupon.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/remote/coupon_remote_data_source.dart';

class CouponRepositoryImpl implements CouponRepository {
  final _remote = CouponRemoteDataSource();

  @override
  Future<List<Coupon>> getAvailableCoupons() async {
    final coupons = await _remote.getCoupons();
    return coupons.where((c) => c.isActive && !c.isExpired).toList();
  }

  @override
  Future<Coupon?> validateCoupon(String code, double orderValue) async {
    final coupons = await getAvailableCoupons();
    final matches = coupons.where((c) => c.code.toLowerCase() == code.trim().toLowerCase());
    if (matches.isEmpty) return null;
    final coupon = matches.first;
    if (orderValue < coupon.minOrderValue) return null;
    return coupon;
  }
}
