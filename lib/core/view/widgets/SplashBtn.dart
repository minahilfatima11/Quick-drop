import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/conts/colors.dart';

class SplashBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SplashBtn({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appOrange,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 10.h),
          child: Text(
            title,
            style: TextStyle(color: AppColors.appWhite),
          ),
        ));
  }
}
