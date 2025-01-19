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
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

import '../../../utils/conts/colors.dart';

class RecieverDetailsPage extends StatefulWidget {
  final VoidCallback onSubmit;

  const RecieverDetailsPage({super.key, required this.onSubmit});
  @override
  State<RecieverDetailsPage> createState() => _RecieverDetailsPageState();
}

class _RecieverDetailsPageState extends State<RecieverDetailsPage> {
  TextEditingController reciverNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "92", // Pakistan ka phone code
    countryCode: "PK", // Pakistan ka country code
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Pakistan", // Country name
    example: "Pakistan", // Example name
    displayName: "Pakistan", // Display name
    displayNameNoCountryCode: "PK", // Display name without country code
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
        if (state is ReciverDetailsPlacedState) {
          SharedPrefService.saveOrderId(state.reciver["order_id"]);
          widget.onSubmit();
        } else if (state is OrderPlaceErrorState) {
          log("${state.error}");
          toastAletMsg(context: context, title: "Error", msg: state.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Receiver Details",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
                ),
                Text(
                  "Please enter the details below",
                ),
                StepperScreenTextField(
                    keyboardType: TextInputType.text,
                    controller: reciverNameController,
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
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    hint: "Enter Email Address",
                    image: 'assets/images/emailIcon.png'),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Receiver address",
                  ),
                ),
                StepperScreenTextField(
                    keyboardType: TextInputType.streetAddress,
                    controller: addressController,
                    hint: "Street/Building",
                    image: 'assets/images/pointIcon.png'),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (state is OrderPlaceLoadingState)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustombuttonWidget(
                            buttonWidth: 200.w,
                            buttonHeight: 40.h,
                            buttonBackgroundColor: AppColors.appOrange,
                            onPressed: () async {
                              var userid = await SharedPrefService.getUserId();

                              // Check if any controller is empty or null
                              if (reciverNameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  mobileNoController.text.isEmpty ||
                                  addressController.text.isEmpty) {
                                // Show dialog box if any field is empty
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      title: Text("Incomplete Details"),
                                      content: Text(
                                          "Please fill in all the required fields."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (!validateEmail(emailController.text)) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      title: Text("Invalid Email"),
                                      content:
                                          Text("Please enter a valid email"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                String mobileNo =
                                    "+${selectedCountry.phoneCode}${mobileNoController.text}";
                                // Proceed if all fields are filled
                                Map<String, dynamic> recieverrDetails = {
                                  "user_id": userid,
                                  "receiver_name": reciverNameController.text,
                                  "receiver_email": emailController.text,
                                  "receiver_mobile": mobileNo,
                                  "receiver_address": addressController.text
                                };
                                log("${recieverrDetails}");
                                context.read<OrderPlaceBloc>().add(
                                      ReciverDetailEvent(
                                          reciever: recieverrDetails),
                                    );
                              }
                            },
                            text: "Submit",
                          ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
