import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderProcessingStatusesDropDownWidget extends StatefulWidget {
  final List<String> items;
  Color? color;
  double ?fontSize;
  final Function(String?) onChanged;
  final String? initialValue; // 🔹 add this

   OrderProcessingStatusesDropDownWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.fontSize,
    this.color
  });

  @override
  State<OrderProcessingStatusesDropDownWidget> createState() =>
      _OrderProcessingStatusesDropDownWidgetState();
}

class _OrderProcessingStatusesDropDownWidgetState
    extends State<OrderProcessingStatusesDropDownWidget> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue; // 🔹 initialize here
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Select status",
        hintStyle: GoogleFonts.dmSans(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: GoogleFonts.dmSans(
        color:widget.color?? Colors.black,
        fontSize:widget.fontSize?? 14,
        fontWeight: FontWeight.w600,
      ),
      items: widget.items.map((String category) {
        return DropdownMenuItem<String>(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
