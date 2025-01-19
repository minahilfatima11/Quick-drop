import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-state.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

import 'otp/mobile_otp_verify.dart';

class MobileTextFieldScreen extends StatefulWidget {
  final String phone;
  final String email;
  final Country selectedCountry;

  const MobileTextFieldScreen(
      {super.key,
      required this.phone,
      required this.email,
      required this.selectedCountry});
  @override
  _MobileTextFieldScreenState createState() => _MobileTextFieldScreenState();
}

class _MobileTextFieldScreenState extends State<MobileTextFieldScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _phoneErrorMessage = null;

  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumberRealtime);
    _phoneController.text = widget.phone;
    selectedCountry = Country(
      phoneCode: widget.selectedCountry.phoneCode,
      countryCode: widget.selectedCountry.countryCode,
      e164Sc: widget.selectedCountry.e164Sc,
      geographic: widget.selectedCountry.geographic,
      level: widget.selectedCountry.level,
      name: widget.selectedCountry.name,
      example: widget.selectedCountry.example,
      displayName: widget.selectedCountry.displayName,
      displayNameNoCountryCode: widget.selectedCountry.displayNameNoCountryCode,
      e164Key: widget.selectedCountry.e164Key,
    );
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumberRealtime);
    _phoneController.dispose();
    super.dispose();
  }

  // Real-time validation for phone number
  void _validatePhoneNumberRealtime() {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneErrorMessage = "Phone number cannot be empty";
      });
    } else if (!RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      setState(() {
        _phoneErrorMessage = "Phone number must contain only digits";
      });
    } else if (phoneNumber.length != 10) {
      setState(() {
        _phoneErrorMessage = "Phone number must be exactly 10 digits";
      });
    } else {
      setState(() {
        _phoneErrorMessage = null; // No error
      });
    }
  }

  // Final validation and navigation
  void _validatePhoneNumber() {
    String phoneNumber = _phoneController.text.trim();
    var p = "${selectedCountry.phoneCode}${_phoneController.text}";
    if (_phoneErrorMessage == null && phoneNumber.isNotEmpty) {
      // If phone number is valid, proceed to OTP screen
      context.read<AuthBloc>().add(SendMobileOtpEvent(mobileNo: p));
    } else {
      // If there's an error, update the error message
      setState(() {
        _phoneErrorMessage =
            _phoneErrorMessage ?? "Please enter a valid phone number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Mobile Number'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSendState) {
            var myphone =
                "${selectedCountry.phoneCode}${_phoneController.text}";
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      MobileOtpVerify(email: widget.email, phone: myphone),
                ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please enter your mobile number to get OTP',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  StepperScreenTextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
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
                    hint: 'Phone',
                  ),
                  if (_phoneErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _phoneErrorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 20),
                  (state is AuthLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustombuttonWidget(
                          buttonBackgroundColor: AppColors.appOrange,
                          onPressed: _validatePhoneNumber,
                          text: "Send OTP",
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
