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

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final images = (json['images'] as List<dynamic>? ?? [])
        .map((img) => (img as Map<String, dynamic>)['url'] as String)
        .toList();
    return Product(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      images: images,
      categoryId: category is Map<String, dynamic> ? (category['_id'] ?? '').toString() : (category ?? '').toString(),
      rating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['numReviews'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      brand: json['brand'] as String? ?? '',
      sizes: List<String>.from(json['sizes'] as List? ?? const []),
      colors: List<String>.from(json['colors'] as List? ?? const []),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }
}
