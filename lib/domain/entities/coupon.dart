class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.minOrderValue,
    required this.expiryDate,
  });

  final String id;
  final String code;
  final String description;
  final double discountPercent;
  final double minOrderValue;
  final DateTime expiryDate;
}
