import 'package:ecommerce_app_my/controllers/update_profile_controller.dart';
import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/login_view.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_button.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class UpdateProfileView extends StatefulWidget {
  String name;
  String email;

  String imageUrl;
  UpdateProfileView({
    super.key,
    required this.email,
    required this.name,

    required this.imageUrl,
  });

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  UpdateProfileController updateProfileController = Get.put(
    UpdateProfileController(),
  );
  String newImageUrl = '';
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  late String selectedGender;
  late String selectedDob;
  @override
  void initState() {
    super.initState();
    updateProfileController.textEditingControllerEmail.value.text =
        widget.email;
    updateProfileController.textEditingControllerName.value.text = widget.name;
  }

  LocalStorage localStorage = LocalStorage();

  final FirestoreServices _firestoreServices = FirestoreServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileImage(),
                const SizedBox(height: 16),
                TextFieldWidget(
                  suffixIcon: Icons.done,
                  title: "Full Name",
                  hintText: 'Update Full Name',
                  controller:
                      updateProfileController.textEditingControllerName.value,
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  suffixIcon: Icons.done,
                  title: "Email",
                  controller:
                      updateProfileController.textEditingControllerEmail.value,
                  hintText: "Update Email",
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 40),
                Obx(() {
                  return ReusableButton(
                    title: "Update",
                    isLoading: updateProfileController.isLoading.value,
                    onPress: () async {
                      if (updateProfileController.selectedImage.value != null) {
                        newImageUrl = await _firestoreServices
                            .uploadImageToCloudinary(
                              updateProfileController.selectedImage.value!,
                              context,
                            );
                      }

                      updateProfileController
                          .updateProfile(
                            updateProfileController
                                    .textEditingControllerEmail
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.email
                                : updateProfileController
                                      .textEditingControllerEmail
                                      .value
                                      .text,
                            updateProfileController
                                    .textEditingControllerName
                                    .value
                                    .text
                                    .isEmpty
                                ? widget.name
                                : updateProfileController
                                      .textEditingControllerName
                                      .value
                                      .text,

                            updateProfileController.selectedImage.value != null
                                ? newImageUrl
                                : widget.imageUrl,
                            // ignore: use_build_context_synchronously
                            context,
                          )
                          .then((value) async {
                            await localStorage.clear("userName");
                            await localStorage.clear("email");

                            await localStorage.clear("imageUrl");
                            await localStorage.clear("userDeviceToken");
                            await localStorage.clear("id");
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ),
                              (route) => false,
                            );
                          });
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Obx(() {
        return InkWell(
          onTap: updateProfileController.pickImageFromGallery,
          child: updateProfileController.selectedImage.value != null
              ? ClipOval(
                  child: Image.file(
                    updateProfileController.selectedImage.value!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
                  child: Image.network(
                    widget.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Icon(Icons.person, size: 40),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
