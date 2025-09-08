class ProductModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String sizes;
  final String stock;
  final String adminId;
  final List<String> imageUrls;
final String category;
  ProductModel({
    required this.adminId,
    required this.description,
    required this.id,
    required this.imageUrls,
    required this.price,
    required this.sizes,
    required this.stock,
    required this.subtitle,
    required this.title,
    required this.category
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'] ?? "",
      adminId: json['adminId'] ?? "",
      description: json['description'] ?? "",
      id: json['id'] ?? "",
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      price: json['price'] ?? "",
      sizes: json['sizes'] ?? "",
      stock: json['stock'] ?? "",
      subtitle: json['subtitle'] ?? "",
      title: json['title'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "adminId": adminId,
      "category":category,
      "description": description,
      "id": id,
      "imageUrls": imageUrls,
      "price": price,
      "sizes": sizes,
      "stock": stock,
      "subtitle": subtitle,
      "title": title,
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, subtitle: $subtitle, '
    'category: $category, '
        'description: $description, price: $price, sizes: $sizes, '
        'stock: $stock, adminId: $adminId, imageUrl: $imageUrls)';
  }
}
