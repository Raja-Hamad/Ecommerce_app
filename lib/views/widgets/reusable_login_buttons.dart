import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReusableLoginButtons extends StatefulWidget {
  Color buttonColor;
  String buttonText;
  String leadingIcon;
  Color textColor;
  Color borderColor;
  ReusableLoginButtons({
    super.key,
    required this.buttonColor,
    required this.buttonText,
    required this.borderColor,
    required this.textColor,
    required this.leadingIcon,
  });

  @override
  State<ReusableLoginButtons> createState() => _ReusableLoginButtonsState();
}

class _ReusableLoginButtonsState extends State<ReusableLoginButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: widget.buttonColor,
      border: Border.all(width: 0.1,
      color: widget.borderColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.leadingIcon,
            height: 20,
            width: 20,
            fit: BoxFit.cover,),
            const SizedBox(width: 20),
            Text(
              widget.buttonText,
              style: GoogleFonts.dmSans(
                color: widget.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
