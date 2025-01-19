import 'dart:async'; // Import this for the Timer

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/view/screens/Home/HomeScreen.dart';

import '../../../../../Api Services/Bloc/Auth-Bloc/auth-events.dart';
import '../../../../../Api Services/Bloc/Auth-Bloc/auth-state.dart';
import '../../../../utils/conts/colors.dart';
import '../../../widgets/custom_button.dart';

class EmaiOtpVerify extends StatefulWidget {
  final String email;

  const EmaiOtpVerify({super.key, required this.email});
  @override
  _EmaiOtpVerifyState createState() => _EmaiOtpVerifyState();
}

class _EmaiOtpVerifyState extends State<EmaiOtpVerify> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _start = 60; // Initial countdown time in seconds
  bool _isButtonEnabled = false; // "Resend OTP" button enabled state
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the timer when the screen opens
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Start a countdown timer
  void _startTimer() {
    _isButtonEnabled = false; // Disable the "Resend OTP" button
    _start = 60; // Reset the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonEnabled = true; // Enable the "Resend OTP" button
        });
        _timer?.cancel(); // Stop the timer
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Resend OTP event
  void _resendOtp() {
    context.read<AuthBloc>().add(SendEmailOtpEvent(email: widget.email));
    _startTimer(); // Restart the timer after resending the OTP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpVerifyState) {
            if (state.data["code"] == "400") {
              setState(() {
                errorMsg = state.data["message"];
              });
            } else if (state.data["code"] == "0") {
              toastAletMsg(
                  title: "Success",
                  msg: "Registered Successfull",
                  context: context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            }
          }
          if (state is AuthFailure) {
            toastAletMsg(context: context, title: "Error", msg: state.error);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please enter the 6-digit OTP sent to your number ${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.h),
                Pinput(
                  length: 6, // Length of the OTP
                  controller:
                      _otpController, // Controller for managing OTP input
                  onCompleted: (pin) {
                    print('OTP Entered: $pin');
                  },
                  showCursor: true, // Show a cursor while entering the OTP
                  onChanged: (value) {
                    print('OTP is being entered: $value');
                  },
                  focusedPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appOrange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (errorMsg.isNotEmpty)
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20.h),
                (state is AuthLoading)
                    ? Center(child: CircularProgressIndicator())
                    : CustombuttonWidget(
                        buttonBackgroundColor: AppColors.appOrange,
                        buttonWidth: 200.w,
                        buttonHeight: 40.h,
                        text: "Verify",
                        onPressed: () {
                          if (_otpController.text.isEmpty) {
                            setState(() {
                              errorMsg = "Please Enter the OTP";
                            });
                          } else {
                            context.read<AuthBloc>().add(OtpVerifyEvent(
                                widget.email,
                                "0000000",
                                "email",
                                _otpController.text));
                          }
                        },
                      ),
                SizedBox(height: 20.h),
                Text(
                  _start > 0
                      ? 'Resend OTP in $_start seconds'
                      : 'You can now resend the OTP.',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: _isButtonEnabled
                      ? _resendOtp
                      : null, // Disable the button until the timer is 0
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: _isButtonEnabled
                          ? AppColors.appOrange
                          : Colors
                              .grey, // Disable color when button is inactive
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
