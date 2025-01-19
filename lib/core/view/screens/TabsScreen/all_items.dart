import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_state.dart';
import 'package:zipline_project/core/view/screens/ItemDetailScreen.dart';
import '../../../../Api Services/Bloc/Orders/orders_event.dart';
import '../../../../Services/shared_preference_helper.dart';
import '../../../utils/conts/colors.dart';
import '../../widgets/homewidgets/OrderCardWidget.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  List<Map<String, dynamic>>? _orders = [];
  List<Map<String, dynamic>>? _filteredOrders = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    int? userId = await SharedPrefService.getUserId();
    // Dispatch event to fetch orders from the API using BLoC
    context.read<OrderBloc>().add(FetchAllOrdersEvent(userId!));
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
          } else if (state is OrderError) {
            // Handle the error and log the message
            log("${state.message}");
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            // Show a loading indicator while orders are being fetched
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is OrderLoaded) {
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
                                    color: const Color.fromARGB(
                                        255, 182, 177, 177)),
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
                SizedBox(height: 10),
                Expanded(
                  child: (_filteredOrders!.isEmpty)
                      ? Center(child: Text("No Orders"))
                      : ListView.builder(
                          itemCount: _filteredOrders?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            var order = _filteredOrders![index];
                            // Parse and format the order date with AM/PM hh:mm a
                            DateTime parsedDate =
                                DateTime.parse(order['order_date']).toUtc();
                            String formattedDate =
                                DateFormat('d MMM yyyy').format(parsedDate);
                            DateTime time = DateFormat("HH:mm:ss")
                                .parse(order['order_time']);
                            String formattedTime = DateFormat.jm().format(time);
                            return OrderCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ItemDetailScreen(
                                      order: order,
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
                        ),
                ),
              ],
            );
          } else {
            return Center(child: Text("No Data Available"));
          }
        },
      ),
    );
  }
}
