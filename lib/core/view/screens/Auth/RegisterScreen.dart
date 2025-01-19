import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-state.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Auth/LoginScreen.dart';
import 'package:zipline_project/core/view/screens/Auth/mobiieOtpSendScreen.dart';
import 'package:zipline_project/core/view/widgets/SplashBtn.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';
import 'package:zipline_project/core/view/widgets/dropdowntextfieldcourierscreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController idProveController = TextEditingController();
  final TextEditingController idfrontController = TextEditingController();
  final TextEditingController profileController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? govtIdFile;
  File? profilePicFile;

  bool obstext = true;
  bool cpobstext = true;
  String? _selectedGender = "";
  String? _selectedtype;
  String? _selectedIDtype;
  bool validateEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    // Check if the email matches the regex and that the entire string is valid
    return emailRegExp.hasMatch(email);
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              log("${state}");
              if (state is AuthRegisterSuccess) {
                String phone = "${phoneController.text}";
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MobileTextFieldScreen(
                        phone: phone,
                        email: emailAddressController.text,
                        selectedCountry: selectedCountry,
                      ),
                    ));
              } else if (state is AuthFailure) {
                log("${state.error}");
                toastAletMsg(
                    title: "Error",
                    msg: "Registered  Failed",
                    context: context);
              }
            },
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                children: [
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Register New Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Please fill in the information below',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    keyboardType: TextInputType.text,
                    hint: ' Name',
                    image: 'assets/images/userIcon.png',
                    controller: nameController,
                  ),
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    keyboardType: TextInputType.emailAddress,
                    hint: ' Email',
                    image: 'assets/images/emailIcon.png',
                    controller: emailAddressController,
                    inputFormatters: [],
                  ),
                  SizedBox(height: 5.h),
                  DropdownTextFormField(
                    items: [
                      'Agent',
                      'Staff',
                    ],
                    hint: 'Select User Type',
                    prefixIcon: Icons.person,
                    suffixIcon: Icons.arrow_drop_down,
                    onChanged: (value) {
                      setState(() {
                        _selectedtype = value!;
                      });
                    },
                  ),
                  StepperScreenTextField(
                    keyboardType: TextInputType.text,
                    isReadable: _selectedtype == "Agent" ? true : false,
                    hint: _selectedtype == "Agent"
                        ? 'Avaiible for Staff Only'
                        : "Company Name",
                    image: 'assets/images/companyIcon.png',
                    controller: companyNameController,
                  ),
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allows only digits
                      LengthLimitingTextInputFormatter(10),
                    ], // Limits input to 10 digits
                    keyboardType: TextInputType.number,
                    hint: ' Phone Number',
                    image: null,
                    controller: phoneController,
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
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    controller: passWordController,
                    hint: "Enter password",
                    image: 'assets/images/passwordIcon.png',
                    obscureText: obstext,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obstext = !obstext;
                          });
                        },
                        icon: Icon((obstext)
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_outlined)),
                  ),
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    controller: confirmPassController,
                    hint: "Confirm password",
                    image: 'assets/images/passwordIcon.png',
                    obscureText: cpobstext,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            cpobstext = !cpobstext;
                          });
                        },
                        icon: Icon((cpobstext)
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_outlined)),
                  ),
                  SizedBox(height: 10.h),
                  StepperScreenTextField(
                    keyboardType: TextInputType.text,
                    hint: ' Address',
                    image: 'assets/images/pointIcon.png',
                    controller: addressController,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 50.h,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            color: AppColors.appOrange.withOpacity(0.3))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              activeColor: AppColors.appOrange.withOpacity(0.7),
                              value: "male",
                              groupValue: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text("Male"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              activeColor: AppColors.appOrange.withOpacity(0.7),
                              value: "female",
                              groupValue: _selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text("Female"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              activeColor: AppColors.appOrange.withOpacity(0.7),
                              value: "Not Disclosed",
                              groupValue: "Not Disclosed",
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Text("Not Disclosed")
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownTextFormField(
                    items: [
                      "Passport",
                      "Voter ID",
                      "National ID",
                      "Driving License"
                    ],
                    hint: "ID Type",
                    prefixIcon: Icons.perm_identity,
                    suffixIcon: Icons.arrow_drop_down,
                    onChanged: (value) {
                      setState(() {
                        _selectedIDtype = value!;
                      });
                    },
                  ),
                  StepperScreenTextField(
                    keyboardType: TextInputType.text,
                    hint: 'ID Prove',
                    image: null,
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: AppColors.appBlack.withOpacity(0.5),
                    ),
                    controller: idProveController,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: StepperScreenTextField(
                          hint: 'Govt ID',
                          controller: idfrontController,
                          image: null,
                          isReadable: true,
                          suffixIcon: IconButton(
                            onPressed: pickFileForIdFront,
                            icon: Icon(
                              Icons.upload_file,
                              color: AppColors.appBlack.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: StepperScreenTextField(
                          hint: 'Profile Picture',
                          image: null,
                          controller: profileController,
                          suffixIcon: IconButton(
                            onPressed: pickImageForProfile,
                            icon: Icon(
                              Icons.add_a_photo,
                              color: AppColors.appBlack.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  (state is AuthLoading)
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : CustombuttonWidget(
                          buttonHeight: 40.h,
                          buttonBackgroundColor: AppColors.appOrange,
                          text: 'Register',
                          onPressed: () async {
                            String phone =
                                "+${selectedCountry.phoneCode}${phoneController.text}";
                            if (nameController.text.isEmpty &&
                                emailAddressController.text.isEmpty &&
                                companyNameController.text.isEmpty &&
                                phoneController.text.isEmpty &&
                                passWordController.text.isEmpty &&
                                confirmPassController.text.isEmpty &&
                                addressController.text.isEmpty &&
                                idProveController.text.isEmpty &&
                                idfrontController.text.isEmpty &&
                                profileController.text.isEmpty &&
                                _selectedGender!.isEmpty &&
                                _selectedtype == null &&
                                _selectedIDtype == null) {
                              showCustomErrorDialog(context);
                            } else if (!validateEmail(
                                emailAddressController.text)) {
                              toastAletMsg(
                                  context: context,
                                  title: "Alert",
                                  msg: "Please enter valid email address");
                            } else {
                              if (passWordController.text ==
                                  confirmPassController.text) {
                                Map<String, dynamic> data = {
                                  'name': nameController.text.trim(),
                                  'email': emailAddressController.text.trim(),
                                  'password': passWordController.text.trim(),
                                  'phone_no': phone,
                                  'company_name ':
                                      companyNameController.text.trim(),
                                  'location': addressController.text.trim(),
                                  'gender': _selectedGender,
                                  'govt_id_proof_number':
                                      idProveController.text,
                                  'govt_id_picture': govtIdFile,
                                  'profile_picture': profilePicFile,
                                  'user_type': _selectedtype,
                                };
                                log("${data}");
                                String mobileNo =
                                    "+${selectedCountry.phoneCode}${phoneController.text}";
                                context.read<AuthBloc>().add(RegisterUserEvent(
                                    name: nameController.text,
                                    email: emailAddressController.text.trim(),
                                    password: passWordController.text,
                                    phoneNo: mobileNo,
                                    companyName: companyNameController.text,
                                    location: addressController.text,
                                    gender: _selectedGender!,
                                    govtIdProofNumber: idProveController.text,
                                    govtIdPicture: govtIdFile!,
                                    profilePicture: profilePicFile!,
                                    userType: _selectedtype!,
                                    govtIdtype: _selectedIDtype!));
                              } else {
                                toastAletMsg(
                                    context: context,
                                    title: "Alert",
                                    msg: "password does not match");
                              }
                            }
                            // Dispatch the data to the AuthBloc to handle registration
                          },
                        ),
                  SizedBox(height: 10.h),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Loginscreen(),
                            ));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 15.sp, color: AppColors.appOrange),
                      ))
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (nameController.text.isEmpty ||
        emailAddressController.text.isEmpty ||
        companyNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passWordController.text.isEmpty ||
        confirmPassController.text.isEmpty ||
        addressController.text.isEmpty ||
        idProveController.text.isEmpty ||
        idfrontController.text.isEmpty ||
        profileController.text.isEmpty ||
        _selectedGender == null ||
        _selectedtype == null) {
      return false;
    }
    return true;
  }

  void showCustomErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.all(20.0),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 30.0),
            SizedBox(width: 15.0),
            Expanded(
              child: Text(
                'Error',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        content: Text(
          'Please fill in all required fields.',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            height: 1.4,
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 20.0, bottom: 15.0),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: Colors.red, // Button background color
              minimumSize: Size(100, 40), // Button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFileForIdFront() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        govtIdFile = File(result.files.single.path!);
        idfrontController.text = result.files.single.name;
      });
    }
  }

  Future<void> pickImageForProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profilePicFile = File(image.path);
        profileController.text = image.name;
      });
    }
  }
}
