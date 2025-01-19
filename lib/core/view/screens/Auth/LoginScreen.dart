import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/view/screens/Home/HomeScreen.dart';
import 'package:zipline_project/core/view/screens/Auth/RegisterScreen.dart';
import 'package:zipline_project/core/view/widgets/Profilewdgts/enabledTextFields.dart';
import 'package:zipline_project/core/view/widgets/SplashBtn.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';

import '../../../utils/Components/alertmsg.dart';
import '../../../utils/conts/colors.dart';
import '../../widgets/custom_button.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthLoginSuccess) {
              if (state.data["code"] == "0") {
                await SharedPrefService.saveUserId(state.data["user_id"]);
                await SharedPrefService.saveLoginStatus(true);
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomePage(),
                    ));
                toastAletMsg(
                    title: "Success",
                    msg: state.data["message"],
                    context: context);
              } else if (state.data["code"] == "404") {
                toastAletMsg(
                    title: "Error",
                    msg: state.data["message"],
                    context: context);
              }
            } else if (state is AuthFailure) {
              toastAletMsg(title: "Error", msg: state.error, context: context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Let's get your login",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Welcome to ZipLinez",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        Center(
                            child: Image.asset(
                          'assets/images/loginArt.png',
                          height: 340.h,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    StepperScreenTextField(
                      controller: emailController,
                      hint: "Enter email address",
                      image: 'assets/images/emailIcon.png',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    StepperScreenTextField(
                      controller: passController,
                      hint: "Enter password",
                      image: 'assets/images/passwordIcon.png',
                      obscureText: obsecure,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                          },
                          icon: Icon((obsecure)
                              ? Icons.visibility_off
                              : Icons.remove_red_eye_outlined)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {}, child: Text("Forget password")),
                      ],
                    ),
                    (state is AuthLoading)
                        ? Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : CustombuttonWidget(
                            buttonHeight: 40.h,
                            buttonBackgroundColor: AppColors.appOrange,
                            text: 'Login',
                            onPressed: () async {
                              if (emailController.text.isEmpty &&
                                  passController.text.isEmpty) {
                              } else {
                                context.read<AuthBloc>().add(LoginUserEvent(
                                    emailController.text, passController.text));
                              }
                              // Dispatch the data to the AuthBloc to handle registration
                            },
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account ?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: Text('Register now')),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
