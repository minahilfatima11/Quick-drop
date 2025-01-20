import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/ItemDetailScreen.dart';
import 'package:zipline_project/core/view/screens/UserSide/SenderSignatureScreen.dart';
import 'package:zipline_project/core/view/widgets/ItemDetailsWidgets/aboutSectionWdgt.dart';
import 'package:zipline_project/core/view/widgets/SplashBtn.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';

class PackagesummaryPage extends StatefulWidget {
  final VoidCallback onSubmit;
  const PackagesummaryPage({super.key, required this.onSubmit});

  @override
  State<PackagesummaryPage> createState() => _PackagesummaryPageState();
}

class _PackagesummaryPageState extends State<PackagesummaryPage> {
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  getApiData() async {
    var id = await SharedPrefService.getOrderId();
    var oid = id.toString();
    log(oid);
    context.read<OrderPlaceBloc>().add(FetchPackageDetailsEvent(orderId: oid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(8.r),
            child: SingleChildScrollView(
              child: BlocBuilder<OrderPlaceBloc, OrderPlaceState>(
                builder: (context, state) {
                  if (state is FetchPackageDetailsState) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 3.h), // Add space between Text widgets
                          Text(
                            "Please view All detail below",
                            style: TextStyle(
                                color: AppColors.appBlack.withOpacity(0.5)),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "About package",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            height: 350.h,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Column(
                                children: [
                                  AboutSecWdgt(
                                      title: "Sender Name",
                                      titleValue: state.package["sender_name"]),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Reciever Name",
                                      titleValue:
                                          state.package["receiver_name"]),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Charges",
                                      titleValue:
                                          "${state.package["charges"]}"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Delivery Required",
                                      titleValue:
                                          "${state.package["delivery_req"]}"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Type",
                                      titleValue:
                                          "${state.package["item_type"]}"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Weight",
                                      titleValue:
                                          "${state.package["item_weight"]}"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Size",
                                      titleValue:
                                          "${state.package["item_size"]}"),
                                  Divider(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  AboutSecWdgt(
                                      title: "Item Category",
                                      titleValue:
                                          "${state.package["item_category"]}")
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 5.h),

                          // StepperScreenTextField(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 Sendersignaturescreen()));
                          //   },
                          //   hint: "Add signature",
                          //   image: 'assets/images/plus.png',
                          //   imageScale: 0.8,
                          //   isReadable: true,
                          // ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                              child: SplashBtn(
                                  title: "Add item",
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Sendersignaturescreen()));
                                  }))
                        ]);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )));
  }
}
