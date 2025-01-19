import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/OrderUIDSectionWidget.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/ProductDetailsSection.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/SenderReceiverSection.dart';

class OrderCard extends StatelessWidget {
  final String orderUID;
  final String status;
  final String senderName;
  final String receiverName;
  final String productImage;
  final String productName;
  final String orderDate;
  final IconData? iconData;
  final Function()? onTap;
  final String orderTime;
  const OrderCard({
    Key? key,
    required this.orderUID,
    required this.status,
    required this.senderName,
    required this.receiverName,
    required this.productImage,
    required this.productName,
    required this.orderDate,
    this.iconData,
    this.onTap,
    required this.orderTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.pink[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderUIDSection(orderUID: orderUID, status: status),
                SizedBox(height: 16.h),
                SenderReceiverSection(
                    senderName: senderName, receiverName: receiverName),
                SizedBox(height: 16.h),
                ProductDetailsSection(
                    orderTime: orderTime,
                    productImage: productImage,
                    productName: productName,
                    orderDate: orderDate,
                    iconData: iconData ?? Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
