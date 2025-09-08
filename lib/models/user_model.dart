import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String email;
 
  final String imageUrl;

  final Timestamp? createdAt;
  final String id;
  final String userDeviceToken;

  UserModel({
 
    required this.email,
    required this.imageUrl,
    required this.userDeviceToken,
    this.createdAt,
    required this.userName,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final createdAt1 = json["createdAt"];
    return UserModel(
      userDeviceToken: json['userDeviceToken'],
      id: json['id'],
    
      email: json['email'],
      imageUrl: json['imageUrl'],
      createdAt: createdAt1 is Timestamp ? json['createdAt'] : null,
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userDeviceToken": userDeviceToken,
      "userName": userName,
    
      'email': email,
      "imageUrl": imageUrl,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'UserModel('
        'userDeviceToken:$userDeviceToken, '
        'id:$id, '
        'userName:$userName, '
       
        'email:$email, '
        'createdAt:$createdAt, '
        'imageUrl:$imageUrl,'
        ')';
  }
}
