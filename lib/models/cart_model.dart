import 'package:ecommerce_app_my/models/product_model.dart';

class CartModel {
  final String id;
  final int ? quantity;
final String? productSize;
  ProductModel productModel;

  CartModel({
    required this.id,
    required this.productModel,
     this.productSize,
     this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productSize: json['productSize'] ?? '',
      id: json['id'] ?? '',
      productModel: ProductModel.fromJson(json['productModel']),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productModel": productModel.toJson(),
      "quantity": quantity,
      "productSize":productSize
    };
  }

  @override
  String toString() {
    return 'CartModel(id: $id, quantity: $quantity, productModel: $productModel, productSize: $productSize)';
  }
}
