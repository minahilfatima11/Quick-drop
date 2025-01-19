import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownTextFormField extends StatelessWidget {
  final List<String> items;
  final String hint;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Function(String?)? onChanged;

  const DropdownTextFormField({
    required this.items,
    required this.hint,
    required this.prefixIcon,
    required this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Color(0xFF2F8392).withOpacity(0.2)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Color(0xFF2F8392).withOpacity(0.2)),
          ),
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration.collapsed(hintText: hint),
          icon: Icon(suffixIcon, color: Colors.grey),
          items: items
              .map(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
          onChanged: onChanged,
          style: TextStyle(fontSize: 16, color: Colors.black),
          hint: Text(hint, style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
