import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderUIDSection extends StatelessWidget {
  final String orderUID;
  final String status;

  const OrderUIDSection({
    Key? key,
    required this.orderUID,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order UID Number\n$orderUID',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            status,
            style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
