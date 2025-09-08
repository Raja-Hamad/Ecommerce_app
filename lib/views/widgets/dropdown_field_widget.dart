import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownFieldWidget extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String?) onChanged;

  const DropdownFieldWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
  });

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {
  String? selectedValue;

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
        DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Select Category",
            hintStyle: GoogleFonts.dmSans(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: widget.items.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged(value);
          },
        ),
        Container(
          height: 0.1,
          width: MediaQuery.of(context).size.width * 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}
