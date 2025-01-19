import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-state.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Auth/email_sendOtp.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

class MobileOtpVerify extends StatefulWidget {
  final String email;
  final String phone;

  const MobileOtpVerify({super.key, required this.email, required this.phone});

  @override
  _MobileOtpVerifyState createState() => _MobileOtpVerifyState();
}

class _MobileOtpVerifyState extends State<MobileOtpVerify> {
  final TextEditingController _otpController = TextEditingController();
  String errorMsg = "";
  int _secondsRemaining = 60; // Set the timer to 60 seconds
  bool _enableResend = false; // Controls visibility of Resend button
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the countdown when the screen loads
  }

  // Starts the countdown timer
  void _startTimer() {
    _secondsRemaining = 60; // Reset the timer duration to 60 seconds
    _enableResend = false; // Disable resend initially
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _enableResend = true; // Enable resend when timer reaches zero
          timer.cancel(); // Stop the timer
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when leaving the screen
    super.dispose();
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
            toastAletMsg(
                context: context, title: "Success", msg: state.data["message"]);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailSendOtpScreen(email: widget.email),
                ));
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
                  'Please enter the 6-digit OTP sent to your number ${widget.phone}',
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
                SizedBox(
                  height: 10.h,
                ),
                if (errorMsg != "")
                  Row(
                    children: [
                      Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                SizedBox(height: 20.h),
                if (state is AuthLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  CustombuttonWidget(
                    buttonBackgroundColor: AppColors.appOrange,
                    buttonWidth: 200.w,
                    buttonHeight: 40.h,
                    text: "Verify",
                    onPressed: () {
                      if (_otpController.text.isEmpty) {
                        setState(() {
                          errorMsg = "Please enter the OTP";
                        });
                      } else {
                        context.read<AuthBloc>().add(OtpVerifyEvent(
                            widget.email,
                            widget.phone,
                            "mobile",
                            _otpController.text));
                      }
                    },
                  ),
                SizedBox(height: 20.h),
                Text(
                  _secondsRemaining > 0
                      ? 'Resend code in $_secondsRemaining seconds'
                      : 'Didn\'t receive the OTP?',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.h),
                if (_enableResend)
                  TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SendMobileOtpEvent(
                              mobileNo: widget.phone,
                            )); // Trigger OTP resend
                        _startTimer(); // Restart the timer after resending OTP
                      },
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(color: AppColors.appOrange),
                      ))
              ],
            ),
          );
        },
      ),
    );
  }
}
