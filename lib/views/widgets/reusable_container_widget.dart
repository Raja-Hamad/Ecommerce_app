import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReusableContainerWidget extends StatefulWidget {
  String conrainerText;
  String title;
  ReusableContainerWidget({
    super.key,
    required this.conrainerText,
    required this.title,
  });

  @override
  State<ReusableContainerWidget> createState() =>
      _ReusableContainerWidgetState();
}

class _ReusableContainerWidgetState extends State<ReusableContainerWidget> {
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              widget.conrainerText,
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
