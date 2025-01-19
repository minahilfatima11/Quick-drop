import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/conts/colors.dart';

class AboutSecWdgt extends StatelessWidget {
  final String title;
  final String titleValue;

  const AboutSecWdgt(
      {super.key, required this.title, required this.titleValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.appBlack.withOpacity(0.5)),
            ),
          ),
          Expanded(
            child: Text(
              titleValue,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
