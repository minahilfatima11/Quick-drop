import 'package:flutter/material.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';

class ProfileTextField extends StatelessWidget {
  final String? hint;
  final String image;
  final Icon? icon;
  const ProfileTextField({super.key, required this.hint, this.icon, required this.image});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelStyle: TextStyle(color: Colors.red),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Image.asset(image,scale: 14,color: AppColors.appBlack.withOpacity(0.5),),
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        border: InputBorder.none
      ),
      obscureText: true,
      enabled: false,
    );
  }
}
