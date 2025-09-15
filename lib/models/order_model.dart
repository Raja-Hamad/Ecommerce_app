import 'package:ecommerce_app_my/models/cart_model.dart';

class OrderModel {
  String id;
  String userId;
  String adminId;
  List<CartModel> cartModel;
  int totalAmount;
  String paymentStatus;
  String paymentMethod;
  AddressModel addressModel;
  String status;

  OrderModel({
    required this.addressModel,
    required this.cartModel,
    required this.id,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.adminId,
    required this.totalAmount,
    required this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      adminId: json['adminId'] ?? '',
      addressModel: AddressModel.fromJson(json['addressModel']),
      cartModel: (json['cartModel'] as List<dynamic>?)
              ?.map((e) => CartModel.fromJson(e))
              .toList() ??
          [],
      id: json['id'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      status: json['status'],
      totalAmount: json['totalAmount'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "cartModel": cartModel.map((e) => e.toJson()).toList(),
      "totalAmount": totalAmount,
      "paymentStatus": paymentStatus,
      "paymentMethod": paymentMethod,
      "addressModel": addressModel.toJson(),
      "adminId":adminId,
      "status": status,
    };
  }

  @override
  String toString() {
    return 'OrderModel('
        'id: $id, '
        'userId: $userId, '
        'cartModel: $cartModel, '
        'totalAmount: $totalAmount, '
        'paymentStatus: $paymentStatus, '
        'paymentMethod: $paymentMethod, '
        'addressModel: $addressModel, '
        'status: $status'
        'adminId: $adminId, '
        ')';
  }
}

class AddressModel {
  String name;
  String phone;
  String fullAddress;
  String city;
  String zipCode;
  String state;
  String callingCode;
  String country;
  String countryCode;
  String id;
  AddressModel({
    required this.city,
    required this.fullAddress,
    required this.name,
    required this.phone,
    required this.callingCode,
    required this.country,
    required this.state,
    required this.zipCode,
    required this.countryCode,
    required this.id

  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] ?? "",
      fullAddress: json['fullAddress'],
      name: json['name'] ?? "",
      phone: json['phone'],
      callingCode: json['callingCode'] ??'',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ??'',
      state: json['state'] ??'',
      countryCode:json['countryCode'] ?? '',
      id: json['id'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "fullAddress": fullAddress,
      "city": city,
      "zipCode":zipCode,
      'country':country,
      "state":state,
      'callingCode':callingCode,
      'countryCode':countryCode,
      'id':id
    };
  }

  @override
  String toString() {
    return 'AddressModel('
        'name:$name, '
        'fullAddress:$fullAddress, '
        'city:$city, '
        'phone:$phone, '
        'callingCode:$callingCode, '
        'zipCode:$zipCode, '
        'state:$state, '
        'country:$country, '
        'countryCode:$countryCode, '
        'id:$id, '
        ')';
  }
}
