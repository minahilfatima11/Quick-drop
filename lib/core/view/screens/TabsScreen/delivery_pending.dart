import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/view/screens/ItemDetailScreen.dart';

import '../../../../Api Services/Bloc/Orders/orders_bloc.dart';
import '../../../utils/conts/colors.dart';
import '../../widgets/homewidgets/OrderCardWidget.dart';

class DeliveryPendingItemsScreen extends StatefulWidget {
  const DeliveryPendingItemsScreen({super.key});

  @override
  State<DeliveryPendingItemsScreen> createState() =>
      _DeliveryPendingItemsScreenState();
}

class _DeliveryPendingItemsScreenState
    extends State<DeliveryPendingItemsScreen> {
  List<Map<String, dynamic>>? _orders = [];
  List<Map<String, dynamic>>? _filteredOrders = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    int? userId = await SharedPrefService
        .getUserId(); // Replace with actual user ID fetching logic
    if (userId != null) {
      // Directly trigger fetching of orders from API via Bloc event
      context.read<OrderBloc>().add(FetchDeliveryPendingOrdersEvent(userId));
    }
  }

  void _filterOrders(String searchQuery) {
    String? selectedItem = _selectedItem;

    setState(() {
      _filteredOrders = _orders?.where((order) {
        bool matchesSearch = order['order_no']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            order['sender_name']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            order['receiver_name']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

        bool matchesItem = selectedItem == null ||
            order['item_name']
                .toString()
                .toLowerCase()
                .contains(selectedItem.toLowerCase());

        return matchesSearch && matchesItem;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoaded) {
            // Update the orders list with new data
            setState(() {
              _orders = state.orders;
              _filteredOrders = state.orders;
            });
            // Apply initial filtering
            _filterOrders('');
          }
        },
        builder: (context, state) {
          if (state is OrderError) {
            // Display error message if there's an error
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is OrderLoading) {
            // Show loading indicator while data is being fetched
            return const Center(child: CircularProgressIndicator());
          }

          // Display the UI
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.appBlack.withOpacity(0.08)),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Search",
                              suffixIcon: Icon(CupertinoIcons.search),
                              hintStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 182, 177, 177)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          onChanged: (value) {
                            _filterOrders(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: (_filteredOrders!.isNotEmpty)
                    ? ListView.builder(
                        itemCount: _filteredOrders?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          var order = _filteredOrders![index];
                          // Parse and format the order date with AM/PM
                          DateTime parsedDate =
                              DateTime.parse(order['order_date']);
                          String formattedDate =
                              DateFormat('d MMM yyyy').format(parsedDate);
                          DateTime time =
                              DateFormat("HH:mm:ss").parse(order['order_time']);

                          // Format it to 12-hour format with am/pm
                          String formattedTime = DateFormat.jm().format(time);
                          return OrderCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                      order:
                                          order // Adjust according to your data model
                                      ),
                                ),
                              );
                            },
                            orderUID: order['order_no'],
                            status: order['order_status'],
                            senderName: order['sender_name'],
                            receiverName: order['receiver_name'],
                            productImage: order['item_image_url'],
                            productName: order['item_name'],
                            orderDate: formattedDate,
                            iconData: Icons.info_outline,
                            orderTime: formattedTime,
                          );
                        },
                      )
                    : Center(
                        child: Text("No Orders"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
