import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/conts/colors.dart';

class StepperScreenTextField extends StatelessWidget {
  final String hint;
  final String? image;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? iconColor;
  final double? imageScale;
  final bool isReadable; // New parameter
  final Function()? onTap;
  StepperScreenTextField({
    Key? key,
    required this.hint,
    this.image,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.borderColor,
    this.labelColor,
    this.hintColor,
    this.iconColor,
    this.prefixIcon,
    this.imageScale,
    this.isReadable = false,
    this.onTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      readOnly: isReadable,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: labelColor ?? Color(0xFF2F8392)),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey),
        prefixIcon: image != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset(
                  image!,
                  scale: imageScale ?? 14,
                  color: iconColor ?? AppColors.appBlack.withOpacity(0.5),
                ),
              )
            : prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFF2F8392).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFF2F8392).withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
