import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-state.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Auth/otp/email_otp_verify.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

class EmailSendOtpScreen extends StatefulWidget {
  final String email;

  const EmailSendOtpScreen({super.key, required this.email});
  @override
  _EmailSendOtpScreenState createState() => _EmailSendOtpScreenState();
}

class _EmailSendOtpScreenState extends State<EmailSendOtpScreen> {
  final TextEditingController _emailController = TextEditingController();
  late var errorMessage = "";

  // Function to simulate sending OTP to the email

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.email;
  }

  void _sendOtp() {
    final email = _emailController.text;
    if (email.isNotEmpty && email.contains('@')) {
      context.read<AuthBloc>().add(SendEmailOtpEvent(email: widget.email));
      log('Sending OTP to: $email');
    } else {
      setState(() {
        errorMessage = "please send valid email";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send OTP'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSendState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EmaiOtpVerify(email: widget.email),
                ));
          } else if (state is AuthFailure) {
            toastAletMsg(context: context, title: "Error", msg: state.error);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter your email to receive an OTP on ${widget.email}',
                      style: TextStyle(fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    StepperScreenTextField(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.appOrange,
                        ),
                        controller: _emailController,
                        hint: "Email"),
                    ...[
                      if (errorMessage != "")
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                    ],
                    SizedBox(height: 20.h),
                    (state is AuthLoading)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustombuttonWidget(
                            buttonWidth: 200.w,
                            onPressed: _sendOtp,
                            text: "Send Otp",
                            buttonBackgroundColor: AppColors.appOrange,
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
