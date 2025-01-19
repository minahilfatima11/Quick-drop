import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String iconPath;

  const ServiceCard({Key? key, required this.title, required this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(right: 6.w), // Responsive padding
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(8.r), // Responsive border radius
            ),
            width: 100.w, // Responsive width
            height: 80.h, // Responsive height
            child: Center(
              child: Image.asset(
                iconPath,
                width: 50.w, // Responsive icon size
              ),
            ),
          ),
          SizedBox(height: 5.h), // Responsive spacing
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp, // Responsive font size
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
