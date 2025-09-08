import 'package:ecommerce_app_my/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessfullySignupView extends StatefulWidget {
  const SuccessfullySignupView({super.key});

  @override
  State<SuccessfullySignupView> createState() => _SuccessfullySignupViewState();
}

class _SuccessfullySignupViewState extends State<SuccessfullySignupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: GestureDetector(
          onTap: () async {
            Get.to(LoginView());
          },
          child: Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                "Start Shopping Now",
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.green,
                  width: 8
                  )
                  ),
                  child: Center(
                    child: Icon(Icons.done,
                    size: 30,
                    color: Colors.green,),
                  ),
                ),
                const SizedBox(height: 30,),
                Text("Successful",
                style: GoogleFonts.dmSans(color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold),),
                 Text("You have successfully registered in",
                style: GoogleFonts.dmSans(color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400),),
                   Text("our app and start working on it",
                style: GoogleFonts.dmSans(color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
