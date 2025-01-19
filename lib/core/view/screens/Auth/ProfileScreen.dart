import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zipline_project/Api%20Services/Bloc/profile-Bloc/profile_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/profile-Bloc/profile_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/profile-Bloc/profile_state.dart';
import 'package:zipline_project/core/view/screens/Auth/LoginScreen.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';
import 'dart:math';

import '../../../../Services/shared_preference_helper.dart';
import '../../../utils/conts/colors.dart';
import '../../widgets/Profilewdgts/TextFieldWdgt.dart';
import '../../widgets/Profilewdgts/enabledTextFields.dart';
import '../../widgets/Profilewdgts/signatureBtn.dart';

enum Gender { male, female }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  // Controllers for TextFields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    // Start the initial animation
    _controller.forward();

    // Set up a timer to reset the animation every 2 minutes
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _resetAnimation();
    });

    _loadProfileData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer
    // Dispose of the controllers when not needed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  void _resetAnimation() {
    _controller.reset();
    _controller.forward();
  }

  Future<void> _loadProfileData() async {
    // Load cached profile data
    profileData = await SharedPrefService.getProfileData();
    int? userid = await SharedPrefService.getUserId();

    if (profileData != null) {
      _updateControllers(profileData!);
    }

    // Fetch new data from the bloc
    context.read<ProfileBloc>().add(ProfileLoadEvent(id: userid!));
  }

  void _updateControllers(Map<String, dynamic> data) {
    _nameController.text = data['name'] ?? '';
    _emailController.text = data['email'] ?? '';
    _phoneController.text = data['phone_no'] ?? '';
    _companyController.text = data['company_name'] ?? '';
    _locationController.text = data['location'] ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Save new profile data when it is loaded
            SharedPrefService.saveProfileData(state.data);
            _updateControllers(state.data);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Border
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(_animation.value),
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.appOrange, // Border color
                            width: 3.w, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: profileData != null &&
                                  profileData!["profile_picture_url"] != null
                              ? NetworkImage(
                                  profileData!["profile_picture_url"])
                              : null,
                          child: profileData == null ||
                                  profileData!["profile_picture_url"] == null
                              ? Icon(
                                  Icons.person,
                                  size: 60.w,
                                  color: Colors.grey.shade600,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // Name TextField
                ProfileEnableTextField(
                  isReadable: true,
                  controller: _nameController,
                  hint: 'Name',
                  image: 'assets/images/userIcon.png',
                ),
                SizedBox(height: 15.h),

                // Email TextField

                ProfileEnableTextField(
                  isReadable: true,
                  controller: _emailController,
                  hint: 'Email',
                  image: 'assets/images/emailIcon.png',
                ),
                SizedBox(height: 15.h),

                // Phone TextField
                ProfileEnableTextField(
                  isReadable: true,
                  controller: _phoneController,
                  hint: 'Phone',
                  image: 'assets/images/phoneIcon.png',
                ),
                SizedBox(height: 15.h),

                // Company Name TextField
                ProfileEnableTextField(
                  controller: _companyController,
                  hint: 'Enter Company Name',
                  image: 'assets/images/companyIcon.png',
                ),
                SizedBox(height: 15.h),

                // Location TextField
                ProfileEnableTextField(
                  controller: _locationController,
                  hint: 'Location',
                  image: 'assets/images/pointIcon.png',
                ),
                SizedBox(height: 20.h),

                // Gender Radio Buttons
                // ID Proof
                // Save Button
                SizedBox(height: 20.h),

                CustombuttonWidget(
                  text: "Logout",
                  textColor: AppColors.appOrange,
                  buttonBackgroundColor: AppColors.appWhite,
                  onPressed: () {
                    SharedPrefService.removeUserId();
                    SharedPrefService.removeProfileData();
                    SharedPrefService.removeLoginStatus();
                    SharedPrefService.removeAllOrders();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginscreen(),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
