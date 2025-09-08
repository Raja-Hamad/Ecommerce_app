import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProductsListTextfield extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  IconData leadingIcon;

  ProductsListTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.leadingIcon,
  });

  @override
  State<ProductsListTextfield> createState() => _ProductsListTextfieldState();
}

class _ProductsListTextfieldState extends State<ProductsListTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(widget.leadingIcon, color: Colors.black),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.dmSans(
              color: Color(0xFFC7C7C7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
