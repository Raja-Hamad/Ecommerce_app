import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id; // notificationId
  final String orderId; // jis order k liye notification bani
  final String userId; // jis user se related hai
  final String adminId; // agar admin ne cancel/update kiya
  final String cancelledBy; // "customer" | "admin"
  final String orderStatus; // "pending" | "cancelled" | "delivered"

  // Product details (lightweight)
  final String productId; // product id
  final String productName; // product title
  final String productImage; // ek thumbnail img url bas

  // Notification meta
  final String notificationTitle;
  final String notificationBody;
  final String notificationReadStatus; // "read" | "unread"
  final Timestamp? createdAt;

  NotificationModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.adminId,
    required this.cancelledBy,
    required this.orderStatus,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.notificationTitle,
    required this.notificationBody,
    required this.notificationReadStatus,
    this.createdAt,
  });

  /// ✅ Convert Firestore Doc -> Model
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      userId: json['userId'] ?? '',
      adminId: json['adminId'] ?? '',
      cancelledBy: json['cancelledBy'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      notificationTitle: json['notificationTitle'] ?? '',
      notificationBody: json['notificationBody'] ?? '',
      notificationReadStatus: json['notificationReadStatus'] ?? 'unread',
      createdAt: json['createdAt'] is Timestamp ? json['createdAt'] : null,
    );
  }

  /// ✅ Convert Model -> Firestore Doc
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderId": orderId,
      "userId": userId,
      "adminId": adminId,
      "cancelledBy": cancelledBy,
      "orderStatus": orderStatus,
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "notificationTitle": notificationTitle,
      "notificationBody": notificationBody,
      "notificationReadStatus": notificationReadStatus,
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  /// ✅ Debugging / Logging Friendly
  @override
  String toString() {
    return 'NotificationModel(id: $id, orderId: $orderId, userId: $userId, adminId: $adminId, '
        'cancelledBy: $cancelledBy, orderStatus: $orderStatus, productId: $productId, '
        'productName: $productName, productImage: $productImage, '
        'notificationTitle: $notificationTitle, notificationBody: $notificationBody, '
        'notificationReadStatus: $notificationReadStatus, createdAt: $createdAt)';
  }
}
