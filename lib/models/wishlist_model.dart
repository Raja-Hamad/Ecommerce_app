import 'package:ecommerce_app_my/models/product_model.dart';

class WishlistModel {
  final String id;
  ProductModel productModel;

  WishlistModel({
    required this.id,
    required this.productModel
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] ?? '',
      productModel: ProductModel.fromJson(json['productModel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productModel": productModel.toJson(),
    };
  }

  @override
  String toString() {
    return 'WishlistModel(id: $id, productModel: $productModel)';
  }
}
