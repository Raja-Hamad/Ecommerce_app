class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    this.brand = '',
    this.sizes = const [],
    this.colors = const [],
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int stock;
  final String brand;
  final List<String> sizes;
  final List<String> colors;
  final bool isFeatured;

  double get displayPrice => discountPrice ?? price;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  int get discountPercent =>
      hasDiscount ? (((price - discountPrice!) / price) * 100).round() : 0;

  bool get inStock => stock > 0;
}
