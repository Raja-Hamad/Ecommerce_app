import 'package:ecommerce_app_my/models/product_model.dart';

class CartModel {
  final String id;
  final int ? quantity;
  ProductModel productModel;

  CartModel({
    required this.id,
    required this.productModel,
     this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
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
    };
  }

  @override
  String toString() {
    return 'CartModel(id: $id, quantity: $quantity, productModel: $productModel)';
  }
}
