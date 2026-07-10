import '../../domain/entities/coupon.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/mock_data_source.dart';

class CouponRepositoryImpl implements CouponRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Coupon>> getAvailableCoupons() async {
    await Future.delayed(_ds.latency);
    return _ds.coupons;
  }

  @override
  Future<Coupon?> validateCoupon(String code, double orderValue) async {
    await Future.delayed(_ds.latency);
    final matches = _ds.coupons.where((c) => c.code.toLowerCase() == code.trim().toLowerCase());
    if (matches.isEmpty) return null;
    final coupon = matches.first;
    if (orderValue < coupon.minOrderValue) return null;
    return coupon;
  }
}
