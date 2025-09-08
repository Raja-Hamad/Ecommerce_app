import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String title;
  IconData suffixIcon;
  bool isObsecure;
  VoidCallback? onPress;
  TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.isObsecure = false,
    required this.suffixIcon,
    this.onPress,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          obscureText: widget.isObsecure,
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
            ),
            suffixIcon: GestureDetector(
              onTap: widget.onPress,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(widget.suffixIcon, color: Colors.white, size: 10),
                ),
              ),
            ),
            hintStyle: GoogleFonts.dmSans(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          height: 0.1,
          width: MediaQuery.of(context).size.width * 1.0,
          decoration: BoxDecoration(color: Colors.black),
        ),
      ],
    );
  }
}
