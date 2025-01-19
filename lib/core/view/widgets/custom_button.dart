import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';

class CustombuttonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final double? buttonWidth;
  final String? text;
  final double? buttonHeight;
  final double? buttonElevation;
  final Color? buttonBackgroundColor;
  final Color? textColor;
  final double? buttonborderRadius;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? borderColor;
  const CustombuttonWidget(
      {Key? key,
      required this.onPressed,
      this.margin,
      this.buttonBackgroundColor,
      this.buttonWidth,
      this.buttonElevation,
      this.buttonHeight,
      this.buttonborderRadius,
      this.fontSize,
      this.fontWeight,
      this.text,
      this.textColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: buttonWidth ?? 330.w,
        height: buttonHeight ?? 45.h,
        // margin: margin ?? const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                elevation: buttonElevation ?? 2,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: borderColor ?? AppColors.appOrange),
                  borderRadius:
                      BorderRadius.circular(buttonborderRadius ?? 8.0),
                ),
                backgroundColor:
                    buttonBackgroundColor ?? const Color(0xff26A4FF)),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: fontSize ?? 17.sp,
                fontWeight: fontWeight ?? FontWeight.w700,
                color: textColor ?? Colors.white,
              ),
            )));
  }
}
