enum DiscountType { percentage, fixed }

class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.expiryDate,
    this.isActive = true,
  });

  final String id;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final double minOrderValue;
  final DateTime expiryDate;
  final bool isActive;

  bool get isPercentage => discountType == DiscountType.percentage;

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  double discountFor(double orderValue) {
    if (orderValue < minOrderValue) return 0;
    return isPercentage ? orderValue * (discountValue / 100) : discountValue;
  }

  String get description => isPercentage
      ? '${discountValue.toInt()}% off on orders above \$${minOrderValue.toInt()}'
      : '\$${discountValue.toInt()} off on orders above \$${minOrderValue.toInt()}';

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      code: json['code'] as String? ?? '',
      discountType: (json['discountType'] as String? ?? 'percentage') == 'fixed' ? DiscountType.fixed : DiscountType.percentage,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0,
      minOrderValue: (json['minimumOrder'] as num?)?.toDouble() ?? 0,
      expiryDate: DateTime.tryParse(json['expiryDate'] as String? ?? '') ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
