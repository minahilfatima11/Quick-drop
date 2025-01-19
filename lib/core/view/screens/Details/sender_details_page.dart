import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

class SenderDetailsPage extends StatefulWidget {
  final VoidCallback onSubmit;

  const SenderDetailsPage({super.key, required this.onSubmit});
  @override
  State<SenderDetailsPage> createState() => _SenderDetailsPageState();
}

class _SenderDetailsPageState extends State<SenderDetailsPage> {
  TextEditingController senderNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  bool validateEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderPlaceBloc, OrderPlaceState>(
      listener: (context, state) {
        if (state is SenderDetailsPlacedState) {
          widget.onSubmit();
        } else if (state is OrderPlaceErrorState) {
          toastAletMsg(context: context, title: "Error", msg: state.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(8.r),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sender Details",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
                ),
                Text(
                  "Please enter the details below",
                ),
                StepperScreenTextField(
                    controller: senderNameController,
                    hint: "Enter your name",
                    image: 'assets/images/userIcon.png'),
                SizedBox(
                  height: 8.h,
                ),
                StepperScreenTextField(
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                    LengthLimitingTextInputFormatter(10),
                  ], // Limits input to 10 digits
                  keyboardType: TextInputType.number,
                  hint: ' Phone Number',
                  image: null,
                  controller: mobileNoController,
                  prefixIcon: Container(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            useSafeArea: true,
                            context: context,
                            countryListTheme: CountryListThemeData(
                                flagSize: 20,
                                borderRadius: BorderRadius.circular(10)),
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                StepperScreenTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]')),
                  ],
                  hint: "Enter Email Address",
                  image: 'assets/images/emailIcon.png',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Sender address",
                  ),
                ),
                StepperScreenTextField(
                    controller: addressController,
                    hint: "Street/Building",
                    image: 'assets/images/pointIcon.png'),
                SizedBox(
                  height: 18.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (state is OrderPlaceLoadingState)
                        ? Center(child: CircularProgressIndicator())
                        : CustombuttonWidget(
                            buttonWidth: 200.w,
                            buttonHeight: 40.h,
                            buttonBackgroundColor: AppColors.appOrange,
                            onPressed: () async {
                              if (senderNameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  mobileNoController.text.isEmpty ||
                                  addressController.text.isEmpty) {
                                showAlertDialog(
                                  context,
                                  "Incomplete Details",
                                  "Please fill in all the required fields.",
                                );
                              } else if (!validateEmail(emailController.text)) {
                                showAlertDialog(
                                  context,
                                  "Invalid Email",
                                  "Please enter a valid email address.",
                                );
                              } else {
                                var orderId =
                                    await SharedPrefService.getOrderId();

                                Map<String, dynamic> sender = {
                                  "order_id": orderId,
                                  "sender_name": senderNameController.text,
                                  "sender_email": emailController.text,
                                  "sender_mobile": mobileNoController.text,
                                  "sender_address": addressController.text
                                };
                                log("${sender}");
                                context
                                    .read<OrderPlaceBloc>()
                                    .add(SenderDetailEvent(sender: sender));
                              }
                            },
                            text: "Submit",
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
