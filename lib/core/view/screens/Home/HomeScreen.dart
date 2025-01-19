import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Auth/LoginScreen.dart';
import 'package:zipline_project/core/view/screens/Auth/ProfileScreen.dart';
import 'package:zipline_project/core/view/screens/ItemDetailScreen.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/TabsScreen.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/OrderCardWidget.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/ServiceListWidget.dart';
import 'package:zipline_project/core/view/widgets/homewidgets/TrackPackages.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? recentOrders;
  List<Map<String, dynamic>>? filteredOrders;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getLoadedData();
  }

  Future<void> getLoadedData() async {
    int? userId = await SharedPrefService.getUserId();
    if (userId != null) {
      List<Map<String, dynamic>>? cachedOrders =
          await SharedPrefService.getRecentOrders();
      if (cachedOrders != null) {
        setState(() {
          recentOrders = cachedOrders;
          filteredOrders = cachedOrders;
        });
      }
      context.read<OrderBloc>().add(FetchRecentOrdersEvent(userId));
    }
  }

  void filterOrders(String query) {
    setState(() {
      searchQuery = query;
      if (recentOrders != null) {
        filteredOrders = recentOrders!.where((order) {
          final orderNo = order['order_no']?.toLowerCase() ?? '';
          final senderName = order['sender_name']?.toLowerCase() ?? '';
          final receiverName = order['receiver_name']?.toLowerCase() ?? '';
          final itemName = order['item_name']?.toLowerCase() ?? '';
          final lowerCaseQuery = query.toLowerCase();
          return orderNo.contains(lowerCaseQuery) ||
              senderName.contains(lowerCaseQuery) ||
              receiverName.contains(lowerCaseQuery) ||
              itemName.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Image.asset(
                        'assets/images/forgetArt.png',
                        height: 40.h,
                      ),
                    ),
                    // Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hello !,',
                          style: TextStyle(
                            color: AppColors.appOrange,
                          ),
                        ),
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: AppColors.appOrange,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30.w,
                    ),

                    CustombuttonWidget(
                        buttonHeight: 30.h,
                        buttonWidth: 100.w,
                        buttonBackgroundColor: AppColors.appOrange,
                        text: "Profile",
                        fontSize: 10.sp,
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ProfileScreen()));
                        })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.r),
        child: SingleChildScrollView(
          child: BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderLoaded) {
                SharedPrefService.saveRecentOrders(state.orders);
                setState(() {
                  recentOrders = state.orders;
                  filteredOrders = state.orders;
                });
              } else if (state is OrderError) {
                log(state.message);
              }
            },
            builder: (context, state) {
              final orders = filteredOrders ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackPackagesCard(),
                  SizedBox(height: 5.h),
                  Text(
                    'Services',
                    style: TextStyle(
                      color: AppColors.appOrange,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ServicesList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Shipping',
                        style: TextStyle(
                          color: AppColors.appOrange,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime parsedDate =
                            DateTime.parse(orders[index]['order_date']).toUtc();
                        String formattedDate =
                            DateFormat('d MMM y').format(parsedDate.toLocal());
                        DateTime time = DateFormat("HH:mm:ss")
                            .parse(orders[index]['order_time']);
                        String formattedTime = DateFormat.jm().format(time);
                        return OrderCard(
                          orderUID: orders[index]['order_no'],
                          status: orders[index]['order_status'],
                          senderName: orders[index]['sender_name'],
                          receiverName: orders[index]['receiver_name'],
                          productImage: orders[index]['item_image_url'],
                          productName: orders[index]['item_name'],
                          orderDate: "${formattedDate}",
                          iconData: Icons.info_outline,
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ItemDetailScreen(
                                          order: orders[index],
                                        )));
                          },
                          orderTime: '${formattedTime}',
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
