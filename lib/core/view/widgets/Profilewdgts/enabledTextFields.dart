import 'package:flutter/material.dart';
import '../../../utils/conts/colors.dart';

class ProfileEnableTextField extends StatelessWidget {
  final String hint;
  final String image;
  final Icon? icon;
  final bool? ObsecureText;
  final bool? isReadable;
  final TextEditingController? controller;

  const ProfileEnableTextField({
    super.key,
    required this.hint,
    this.icon,
    required this.image,
    this.ObsecureText,
    this.isReadable,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadable ?? false,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.red),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Image.asset(image,
            scale: 14, color: AppColors.appBlack.withOpacity(0.5)),
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.2)),
        ),
      ),
      obscureText: false,
    );
  }
}
