class TopSellingProduct {
  final String productId;
  final String name;
  final double price;
  final int totalSold;
  final List<String> images;

  const TopSellingProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.totalSold,
    required this.images,
  });

  String get firstImageUrl => images.isNotEmpty ? images.first : '';

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    final images = (json['image'] as List<dynamic>? ?? [])
        .map((img) => (img as Map<String, dynamic>)['url'] as String? ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
    return TopSellingProduct(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      totalSold: (json['totalSold'] as num?)?.toInt() ?? 0,
      images: images,
    );
  }
}
