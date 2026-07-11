class Category {
  const Category({required this.id, required this.name, required this.imageUrl, this.productCount = 0});

  final String id;
  final String name;
  final String imageUrl;
  final int productCount;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      imageUrl: (json['image'] as Map<String, dynamic>?)?['url'] as String? ?? '',
    );
  }
}
