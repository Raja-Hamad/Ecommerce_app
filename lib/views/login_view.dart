import 'package:ecommerce_app_my/controllers/login_controller.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_button.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_login_buttons.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
   void disposeValues(){
    _controller.emailController.value.clear();
    _controller.passwordController.value.clear();
  }
  var isObsecure = false;
  final LoginController _controller = Get.put(LoginController());
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
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Fashions",
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 30,
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
                const SizedBox(height: 50),
                Text(
                  "Welcome!",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please login or signup to continue our app",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                TextFieldWidget(
                  controller: _controller.emailController.value,
                  hintText: 'Enter your email',
                  suffixIcon: Icons.done,
                  title: "Email",
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                  isObsecure: isObsecure,
                  onPress: () {
                    setState(() {
                      isObsecure =! isObsecure;
                    });
                  },
                  controller: _controller.passwordController.value,
                  hintText: 'Enter your password',
                  suffixIcon: isObsecure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  title: "Password",
                ),
                const SizedBox(height: 60),
                ReusableButton(
                  isLoading: _controller.isLoading.value,
                  title: "Login", onPress: () {
                     FocusScope.of(context).unfocus();

                    _controller.loginAdmin(
                      email: _controller.emailController.value.text.trim(),
                      password: _controller.passwordController.value.text.trim(),
                      context: context,
                    ).then((value){
                      disposeValues();
                    }).onError((error,stackTrace){
                      if(kDebugMode){
                        print("Error is $error");
                      }
                    });
                }),
                const SizedBox(height: 20),
                ReusableLoginButtons(
                  borderColor: Colors.blueAccent,
                  buttonColor: Colors.blueAccent,
                  buttonText: "Continue with Facebook",
                  textColor: Colors.white,
                  leadingIcon: "assets/images/fb_logo.png",
                ),
                const SizedBox(height: 10),
                ReusableLoginButtons(
                  borderColor: Colors.black,
                  buttonColor: Colors.transparent,
                  buttonText: "Continue with Google",
                  textColor: Colors.black,
                  leadingIcon: "assets/images/google_logo.png",
                ),
                const SizedBox(height: 10),
                ReusableLoginButtons(
                  borderColor: Colors.black,
                  buttonColor: Colors.transparent,
                  buttonText: "Continue with Apple",
                  textColor: Colors.black,
                  leadingIcon: "assets/images/iphone_logo.png",
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
