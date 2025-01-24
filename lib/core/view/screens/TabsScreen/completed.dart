import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_state.dart';
import 'package:zipline_project/core/view/screens/ItemDetailScreen.dart';
import '../../../../Api Services/Bloc/Orders/orders_bloc.dart';
import '../../../../Services/shared_preference_helper.dart';
import '../../../utils/conts/colors.dart';
import '../../widgets/homewidgets/OrderCardWidget.dart';

class CompletedItemsScreen extends StatefulWidget {
  const CompletedItemsScreen({super.key});

  @override
  State<CompletedItemsScreen> createState() => _CompletedItemsScreenState();
}

class _CompletedItemsScreenState extends State<CompletedItemsScreen> {
  List<Map<String, dynamic>>? _filteredOrders = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    // Get user ID (or manage it differently if required)
    int? userId = await SharedPrefService.getUserId();
    if (userId != null) {
      // Fetch data from the API using Bloc
      context.read<OrderBloc>().add(FetchCompletedOrdersEvent(userId));
    }
  }

  void _filterOrders(String searchQuery, List<Map<String, dynamic>> orders) {
    String? selectedItem = _selectedItem;

    setState(() {
      _filteredOrders = orders.where((order) {
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
            // Directly use the fetched data
            setState(() {
              _filteredOrders = state.orders;
            });
            // Apply initial filtering
            _filterOrders('', state.orders);
          } else if (state is OrderError) {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
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
                            color: AppColors.appBlack.withOpacity(0.08),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search",
                              suffixIcon: Icon(CupertinoIcons.search),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 182, 177, 177),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              _filterOrders(value, state.orders);
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

                            // Parse and format the order date with AM/PM
                            DateTime parsedDate =
                                DateTime.parse(order['order_date']);
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
