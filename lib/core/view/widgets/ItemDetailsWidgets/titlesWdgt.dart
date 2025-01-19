import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/conts/colors.dart';

class TitlesWdgt extends StatelessWidget {
  final String Title;
  const TitlesWdgt({super.key, required this.Title});

  @override
  Widget build(BuildContext context) {
    return Text(
      Title,
      style: TextStyle(
          color: AppColors.appBlack,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800),
    );
  }
}
