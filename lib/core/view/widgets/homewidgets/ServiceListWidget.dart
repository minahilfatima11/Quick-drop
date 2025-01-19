import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/core/view/screens/Details/courier.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/TabsScreen.dart';
import 'ServiceCardWidgets.dart';

class ServicesList extends StatelessWidget {
  final List<Map<String, String>> services = [
    {'title': 'Add Drop Item', 'icon': 'assets/images/boxDrop.png'},
    {'title': 'All Items', 'icon': 'assets/images/boxPick.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      child: Wrap(
        spacing: 8.w, // spacing between items horizontally
        runSpacing: 16.h, // spacing between items vertically
        alignment: WrapAlignment.center, // align items in center
        children: List.generate(services.length, (index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CourierScreen()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TabMainScreen()));
              }
              // Add more conditions if needed
            },
            child: Container(
              width: 120.w,
              child: ServiceCard(
                title: services[index]['title']!,
                iconPath: services[index]['icon']!,
              ),
            ),
          );
        }),
      ),
    );
  }
}
