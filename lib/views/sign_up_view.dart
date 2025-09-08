import 'dart:io';

import 'package:ecommerce_app_my/controllers/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_button.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isChecked = false;
  var isObsecure = false;
  final SignupController _controller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Fashions",
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "My Life My Styles",
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Sign Up",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create a new account",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Obx(() {
                    return InkWell(
                      onTap: _controller.pickImageFromGallery,
                      child: _controller.selectedImage.value == null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: const Icon(Icons.camera_alt),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                40,
                              ), // Make it circular
                              child: Image.file(
                                _controller.selectedImage.value!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                    );
                  }),
                ),
                const SizedBox(height: 15),
                TextFieldWidget(
                  controller: _controller.nameController.value,
                  hintText: 'Enter your user name',
                  suffixIcon: Icons.done,
                  title: "User Name",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.emailController.value,
                  hintText: 'Enter your email',
                  suffixIcon: Icons.done,
                  title: "Email",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  isObsecure: isObsecure,
                  onPress: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  controller: _controller.passwordController.value,
                  hintText: 'Enter your password',
                  suffixIcon: isObsecure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  title: "Password",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  isObsecure: isObsecure,
                  onPress: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  controller: _controller.confirmPasswordController.value,
                  hintText: 'Confirm your password',
                  suffixIcon: isObsecure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  title: "Confirm Password",
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: isChecked ? Colors.black : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 0.4),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.done,
                            color: isChecked
                                ? Colors.white
                                : Colors.transparent,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          "By creating an account you have to",
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          "continue with our terms & conditions",
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ReusableButton(
                  title: "Signup",
                  isLoading: _controller.isLoading.value,
                  onPress: () {
                    _controller.registerAdmin(
                      image: _controller.selectedImage.value != null
                          ? File(_controller.selectedImage.value!.path)
                          : null,
                    
                      name: _controller.nameController.value.text
                          .trim()
                          .toString(),
                      email: _controller.emailController.value.text
                          .trim()
                          .toString(),
                      password: _controller.passwordController.value.text
                          .trim()
                          .toString(),
                      context: context,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
