import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/conts/colors.dart';

class ProductDetailsSection extends StatefulWidget {
  final String productImage;
  final String productName;
  final String orderDate;
  final String orderTime;
  final IconData? iconData;

  const ProductDetailsSection({
    Key? key,
    required this.productImage,
    required this.productName,
    required this.orderDate,
    this.iconData,
    required this.orderTime,
  }) : super(key: key);

  @override
  State<ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<ProductDetailsSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            widget.productImage,
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold , color: AppColors.appOrange),
            ),
            SizedBox(height: 8.h),
            Text(
              "${widget.orderDate},${widget.orderTime}",
              style: TextStyle(fontSize: 14.sp, color: AppColors.appOrange.withOpacity(0.7)),
            ),
          ],
        ),
        const Spacer(),
        Icon(Icons.arrow_forward_ios, color: AppColors.appOrange,),
      ],
    );
  }
}
