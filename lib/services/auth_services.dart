import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/user_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/add_product.dart';
import 'package:ecommerce_app_my/views/bottom_nav_bar.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LocalStorage localStorage = LocalStorage();

  // Register admin
  Future<String?> registerAdmin(
    String name,
    String email,
    String password,

    String imageUrl,
  ) async {
    try {
      final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userDeviceToken = await FirebaseMessaging.instance.getToken();
      if (userDeviceToken != null) {
        UserModel user = UserModel(
          userDeviceToken: userDeviceToken,

          id: userCred.user!.uid,
          userName: name,
          email: email,
          imageUrl: imageUrl,
        );
        final createdAt = user.toMap();
        createdAt['createdAt'] =
            FieldValue.serverTimestamp(); // Add timestamp manually

        await _firestore.collection('users').doc(user.id).set(user.toMap());
        return null; // success
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  // Login admin
  Future<String?> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user document from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return "User data not found!";
      }

      // Convert Firestore doc to UserModel
      UserModel loggedInUser = UserModel(
        userDeviceToken: userDoc['userDeviceToken'],
        id: userDoc['id'],
        userName: userDoc['userName'],
        email: userDoc['email'],
        imageUrl: userDoc['imageUrl'],
      );
      // if (userDoc['role'] == "Admin") {
      //   // Get.offAll(AdminNavBar());
      // } else {
      //   // ignore: use_build_context_synchronously
      //   // Get.offAll(BottomNavBarView());
      // }
      Get.to(BottomNavBarView());
      // Store user data locally
      await storeUserDataLocally(loggedInUser);

      return null; // success
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error while storing data locally ${e.message}");
      }
      return e.message;
    } catch (e) {
      if (kDebugMode) {
        print("Error is ${e.toString()}");
      }
      return e.toString();
    }
  }

  Future<void> storeUserDataLocally(UserModel user) async {
    LocalStorage localStorage = LocalStorage();

    await localStorage.setValue('id', user.id);
    await localStorage.setValue('email', user.email);
    await localStorage.setValue('userName', user.userName);
    await localStorage.setValue("userDeviceToken", user.userDeviceToken);

    await localStorage.setValue("imageUrl", user.imageUrl);

    // Check values to verify
    String? id = await localStorage.getValue('id');
    String? email = await localStorage.getValue('email');
    String? name = await localStorage.getValue('userName');
    String? userDeviceToken = await localStorage.getValue("userDeviceToken");

    String? imageUrl = await localStorage.getValue("imageUrl");

    if (kDebugMode) {
      print("Stored User Data:");
      print("ID: $id");
      print("Email: $email");
      print("Name: $name");
      print("Device: $userDeviceToken");

      print("image: $imageUrl");
    }
  }

  Future<void> updateProfile(
    String email,
    String name,
    BuildContext context,
  ) async {
    try {
      String? id = await localStorage.getValue("id");
      await _firestore.collection("users").doc(id).update({
        "email": email,
        "name": name,
      });
      FlushBarMessages.successMessageFlushBar(
        "Profile Updated successfully",
        // ignore: use_build_context_synchronously
        context,
      );
    } catch (e) {
      FlushBarMessages.errorMessageFlushBar(
        "Error while updating the user profile ${e.toString()}",
        // ignore: use_build_context_synchronously
        context,
      );
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently signed in.')),
      );
      return;
    }

    // Create credential with current email and password
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      // Re-authenticate the user
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Password updated successfully.')));
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'wrong-password') {
        message = 'The current password is incorrect.';
      } else if (e.code == 'requires-recent-login') {
        message = 'Please log in again and try to update your password.';
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('An unexpected error occurred.')));
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final result = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        email,
      );
      return result
          .isNotEmpty; // Agar empty nahi hai, matlab email registered hai
    } catch (e) {
      return false;
    }
  }
}
