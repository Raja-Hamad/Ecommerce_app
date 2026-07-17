import 'product.dart';

class AdminProductsPage {
  final int currentPage;
  final int totalPages;
  final int totalProducts;
  final List<Product> products;

  const AdminProductsPage({
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
    required this.products,
  });

  bool get hasMore => currentPage < totalPages;

  factory AdminProductsPage.fromJson(Map<String, dynamic> json) {
    final list = json['products'] as List<dynamic>? ?? [];
    return AdminProductsPage(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      products: list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
