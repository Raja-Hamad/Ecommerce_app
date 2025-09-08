import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/models/product_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> uploadImageToCloudinary(
    File imageFile,
    BuildContext context,
  ) async {
    final cloudName = 'dqs1y6urv'; // Replace with your Cloudinary Cloud Name
    final apiKey = '463369248646777'; // Replace with your Cloudinary API Key
    final preset =
        'ecommerce_preset'; // Replace with your Cloudinary Upload Preset

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = preset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      // FlushBarMessages.successMessageFlushBar(
      //   "Image Uploaded Successfully",
      //   // ignore: use_build_context_synchronously
      //   context,
      // );
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url']; // Image URL from Cloudinary
    } else {
      // ignore: use_build_context_synchronously
      FlushBarMessages.errorMessageFlushBar("Failed to upload Image", context);
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<String> uploadPdfToCloudinary(
    File pdfFile,
    BuildContext context,
  ) async {
    final cloudName = 'dqs1y6urv';
    final apiKey = '463369248646777';
    final preset = 'ecommerce_preset';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/raw/upload', // use `raw` for PDFs
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = preset
      ..files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(res.body);
      FlushBarMessages.successMessageFlushBar(
        "Resume uploaded successfully",
        // ignore: use_build_context_synchronously
        context,
      );
      return data['secure_url'];
    } else {
      FlushBarMessages.errorMessageFlushBar(
        "Failed to upload Resume PDF",
        // ignore: use_build_context_synchronously
        context,
      );
      throw Exception('Failed to upload resume PDF to Cloudinary');
    }
  }

  Future<void> addProduct(BuildContext context, ProductModel model) async {
    try {
      await _firebaseFirestore
          .collection("products")
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      if (kDebugMode) {
        print("Error while adding product is ${e.toString()}");
      }
    }
  }

  Future<void> addToCartOrWishList(BuildContext context, var model, String collectionName) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      if (kDebugMode) {
        print("Error while adding product to cart is ${e.toString()}");
      }
    }
  }
}
