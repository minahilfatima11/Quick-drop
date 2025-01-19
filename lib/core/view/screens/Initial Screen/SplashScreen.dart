import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zipline_project/core/view/screens/Home/HomeScreen.dart';
import 'dart:async';

import 'package:zipline_project/core/view/screens/Initial%20Screen/SplashScreenTwo.dart';

import '../../../../Services/shared_preference_helper.dart'; // Import the SharedPrefService

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check login status
    bool isLoggedIn = await SharedPrefService.getLoginStatus();
    log("${isLoggedIn}");

    // Navigate based on login status
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? HomePage() : Splashscreentwo(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splashone.png'),
      ),
    );
  }
}
