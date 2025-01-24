import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_bloc.dart';
import 'package:zipline_project/core/view/screens/UserSide/reciver_signature.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';
import '../../../Api Services/Bloc/Orders/orders_event.dart';
import '../../../Api Services/Bloc/Orders/orders_state.dart';
import '../../../Services/shared_preference_helper.dart';
import '../../utils/conts/colors.dart';
import '../widgets/ItemDetailsWidgets/aboutSectionWdgt.dart';
import '../widgets/ItemDetailsWidgets/titlesWdgt.dart';

class ItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? order;
  const ItemDetailScreen({super.key, this.order});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Map<String, dynamic>? _orderDetails;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
    // Fetch fresh data from API if not available in cache
    context
        .read<OrderBloc>()
        .add(FetchOrderDetailsEvent(widget.order!["order_no"]!));
  }

  void _loadOrderDetails() async {
    final cachedOrderDetails = await _getOrderDetailsFromSharedPreferences();
    if (cachedOrderDetails != null) {
      setState(() {
        _orderDetails = cachedOrderDetails;
      });
    }
  }

  Future<Map<String, dynamic>?> _getOrderDetailsFromSharedPreferences() async {
    return await SharedPrefService.getOrderDetailsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is OrderDetailLoaded) {
          // Save data to SharedPreferences
          SharedPrefService.saveOrderDetails(state.ordersDetails);
          setState(() {
            _orderDetails = state.ordersDetails;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Item Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(

                decoration: BoxDecoration(
                  color: AppColors.appOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.order!["order_status"] ?? "",
                    style:
                        TextStyle(fontSize: 10.sp, color: AppColors.appWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _orderDetails == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      TitlesWdgt(Title: "Sender Information"),
                      SizedBox(height: 10.h),
                      _buildDetailsBox([
                        AboutSecWdgt(
                            title: "Name",
                            titleValue: _orderDetails!["sender_name"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Contact No.",
                            titleValue:
                                _orderDetails!["sender_mobile"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Email Id",
                            titleValue:
                                _orderDetails!["sender_email"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Address",
                            titleValue:
                                _orderDetails!["sender_address"] ?? "N/A"),
                      ]),
                      SizedBox(height: 15.h),
                      TitlesWdgt(Title: "Receivers Information"),
                      SizedBox(height: 10.h),
                      _buildDetailsBox([
                        AboutSecWdgt(
                            title: "Name",
                            titleValue:
                                _orderDetails!["receiver_name"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Contact No.",
                            titleValue:
                                _orderDetails!["receiver_mobile"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Email Id",
                            titleValue:
                                _orderDetails!["receiver_email"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Address",
                            titleValue:
                                _orderDetails!["receiver_address"] ?? "N/A"),
                      ]),
                      SizedBox(height: 15.h),
                      TitlesWdgt(Title: "Package Details"),
                      SizedBox(height: 10.h),
                      _buildDetailsBox([
                        AboutSecWdgt(
                            title: "Item Name",
                            titleValue: _orderDetails!["item_name"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Item Size",
                            titleValue: _orderDetails!["item_size"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Item Weight",
                            titleValue: "${_orderDetails!["item_weight"]}"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Charges",
                            titleValue: "${_orderDetails!["charges"]}"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Item Type",
                            titleValue: _orderDetails!["item_type"] ?? "N/A"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        AboutSecWdgt(
                            title: "Item Category",
                            titleValue:
                                _orderDetails!["item_category"] ?? "N/A"),
                      ]),
                      SizedBox(
                        height: 10.h,
                      ),
                      TitlesWdgt(
                        Title: "Sender Signature",
                      ),
                      _buildDetailsBox([
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 200.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      _orderDetails!["sender_sign_img"]))),
                        )
                      ]),
                      (widget.order!["order_status"] == "delivered" ||
                              widget.order!["order_status"] == "completed")
                          ? TitlesWdgt(
                              Title: "Receiver Signature",
                            )
                          : Container(),
                      _buildDetailsBox([
                        (widget.order!["order_status"] == "delivered" ||
                                widget.order!["order_status"] == "completed")
                            ? Container(
                                margin: EdgeInsets.all(10),
                                height: 200.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    image: DecorationImage(
                                        image: NetworkImage(_orderDetails![
                                            "receiver_sign_img"]))),
                              )
                            : Container()
                      ]),
                      (widget.order!["order_status"] == "Delivery Pending" ||
                              widget.order!["order_status"] ==
                                  "Pick Up Pending")
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustombuttonWidget(
                                  buttonWidth: 200.w,
                                  buttonHeight: 40,
                                  buttonBackgroundColor: AppColors.appOrange,
                                  fontSize: 12.sp,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoDialogRoute(
                                            builder: (context) =>
                                                Reciversignaturescreen(
                                                  order: widget.order!,
                                                ),
                                            context: context));
                                  },
                                  text: "Receiver Signature",

                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDetailsBox(List<Widget> widgets) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appOrange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),

      ),
      child: Column(
        children: widgets,
      ),
    );
  }
}
