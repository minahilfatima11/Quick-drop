import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Auth/LoginScreen.dart';
import 'package:zipline_project/core/view/widgets/SplashBtn.dart';

class Splashscreentwo extends StatefulWidget {
  const Splashscreentwo({super.key});

  @override
  State<Splashscreentwo> createState() => _SplashscreentwoState();
}

class _SplashscreentwoState extends State<Splashscreentwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Skip",
                  style:
                      TextStyle(color: Color(0xFF8C52FF), fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) => Loginscreen()
                      ),
                    );
                  },
                  child: Container(
                    width: 40.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: AppColors.appOrange,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.appWhite,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/splashtwo.png'),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                //color: AppColors.appOrange.withOpacity(0.2),
                // Background color of the container
                borderRadius: BorderRadius.circular(20.r), // Rounded corners
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To QuickDrop',
                      style: TextStyle(
                        color: AppColors.appOrange,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h), // Space between text and description
                    Text(
                      'Fast and reliable deliveries at your fingertips. From parcels to packages, we make shipping effortless and efficient.',
                      style: TextStyle(
                        color: AppColors.appOrange,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    SplashBtn(
                      title: "Get Started",
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(
                              builder: (context) => Loginscreen()
                        ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
