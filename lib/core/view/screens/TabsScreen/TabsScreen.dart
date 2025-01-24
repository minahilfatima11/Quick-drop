import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/all_items.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/completed.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/delivered.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/delivery_pending.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/pickup_pending.dart';

import '../../widgets/custom_button.dart';

class TabMainScreen extends StatefulWidget {
  const TabMainScreen({
    super.key,
  });

  @override
  State<TabMainScreen> createState() => _TabMainScreenState();
}

class _TabMainScreenState extends State<TabMainScreen> {
  final List<String> itemsList = const [
    'All',
    'Completed',
    'Delivered',
    'Pickup Pending',
    'Delivery Pending'
  ];
  var currentIndex = 0;
  int selectedCategoryIndex = 0; // Initialize with the index of 'All'

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  (selectedCategoryIndex == 0)
                      ? "All ITEMS"
                      : (selectedCategoryIndex == 1)
                          ? "Completed".toUpperCase()
                          : (selectedCategoryIndex == 2)
                              ? "Delivered".toUpperCase()
                              : (selectedCategoryIndex == 3)
                                  ? "Pickup Pending".toUpperCase()
                                  : (selectedCategoryIndex == 4)
                                      ? "Delivery Pending".toUpperCase()
                                      : "Items".toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.spMin),
                ),
                Container()
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10.r)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustombuttonWidget(
                          buttonHeight: 35.h,
                          buttonWidth: 80.w,
                          buttonBackgroundColor: (selectedCategoryIndex == 0)
                              ? AppColors.appOrange
                              : Colors.white,
                          textColor: (selectedCategoryIndex == 0)
                              ? Colors.white
                              : AppColors.appOrange,
                          text: itemsList[0],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            changeScreen(0);
                          }),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustombuttonWidget(
                          buttonHeight: 35.h,
                          buttonWidth: 120.w,
                          buttonBackgroundColor: (selectedCategoryIndex == 1)
                              ? AppColors.appOrange
                              : Colors.white,
                          textColor: (selectedCategoryIndex == 1)
                              ? Colors.white
                              : AppColors.appOrange,
                          text: itemsList[1],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            changeScreen(1);
                          }),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustombuttonWidget(
                          buttonHeight: 35.h,
                          buttonWidth: 120.w,
                          text: itemsList[2],
                          buttonBackgroundColor: (selectedCategoryIndex == 2)
                              ? AppColors.appOrange
                              : Colors.white,
                          textColor: (selectedCategoryIndex == 2)
                              ? Colors.white
                              : AppColors.appOrange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            changeScreen(2);
                          }),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustombuttonWidget(
                          buttonHeight: 35.h,
                          buttonWidth: 150.w,
                          text: itemsList[3],
                          buttonBackgroundColor: (selectedCategoryIndex == 3)
                              ? AppColors.appOrange
                              : Colors.white,
                          textColor: (selectedCategoryIndex == 3)
                              ? Colors.white
                              : AppColors.appOrange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            changeScreen(3);
                          }),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustombuttonWidget(
                          buttonHeight: 35.h,
                          buttonWidth: 170.w,
                          text: itemsList[4],
                          buttonBackgroundColor: (selectedCategoryIndex == 4)
                              ? AppColors.appOrange
                              : Colors.white,
                          textColor: (selectedCategoryIndex == 4)
                              ? Colors.white
                              : AppColors.appOrange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            changeScreen(4);
                          }),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildContent(selectedCategoryIndex),
            ),
          ],
        ),
      ),
    );
  }

  void changeScreen(int screenIndex) {
    setState(() {
      selectedCategoryIndex = screenIndex;
    });
  }
}

Widget _buildContent(int selectedCategoryIndex) {
  // You can conditionally build the content based on the selected category index.
  // Implement the content for each category screen as needed.
  if (selectedCategoryIndex == 0) {
    return const AllItemsScreen();
  } else if (selectedCategoryIndex == 1) {
    return const CompletedItemsScreen();
  } else if (selectedCategoryIndex == 2) {
    return const DeliveredItemsScreen();
  } else if (selectedCategoryIndex == 3) {
    return const PickupPendingItemsScreen();
  } else if (selectedCategoryIndex == 4) {
    return const DeliveryPendingItemsScreen();
  } else {
    // Handle other indices or default to AllProductScreen.
    return const AllItemsScreen();
  }
}
