class Category {
  const Category({required this.id, required this.name, required this.imageUrl, this.productCount = 0});

  final String id;
  final String name;
  final String imageUrl;
  final int productCount;
}
