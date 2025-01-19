import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/conts/api_constant.dart';

class AuthRepo {
  final Dio _client = Dio();

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    required String phoneNo,
    required String companyName,
    required String location,
    required String gender,
    required String govtIdProofNumber,
    required File govtIdPicture,
    required File profilePicture,
    required String userType,
    required String govtProofType,
  }) async {
    try {
      Response response = await _client.post(
        '$BASE_URL${ApiConstant.registerEndpoint}',
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'password': password,
          'phone_no': phoneNo,
          'company_name': companyName,
          'location': location,
          'gender': gender,
          'govt_id_proof_number': govtIdProofNumber,
          'govt_id_picture': await MultipartFile.fromFile(govtIdPicture.path),
          'profile_picture': await MultipartFile.fromFile(profilePicture.path),
          'user_type': userType,
          "govt_proof_type": govtIdProofNumber
        }),
      );
      await SharedPrefService.saveUserId(response.data["user_id"]);
      return response.data;
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _client.post(
        '$BASE_URL${ApiConstant.loginEndpoint}',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return response.data; // Return the server's response data
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> SendMobileOtp(String mobileNo) async {
    try {
      Response response = await _client.post(
        '$BASE_URL/register/mobile/verify',
        data: {"mobile_no": mobileNo},
      );
      if (response.statusCode == 200) {
        return response.data; // Return the server's response data
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> SendEmailOtp(String email) async {
    try {
      Response response = await _client.post(
        '$BASE_URL/register/email/verify',
        data: {
          "email": email,
        },
      );
      if (response.statusCode == 200) {
        return response.data; // Return the server's response data
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> verifyOtp(
      String mobileNo, String email, String channel, String otp) async {
    try {
      Response response = await _client.post(
        '$BASE_URL/register/auth',
        data: {
          "channel": channel, //use "email" to verify email OTP
          "otp": otp,
          "mobile_no": mobileNo, //NA will come, when channel is email
          "email": email
        },
      );
      if (response.statusCode == 200) {
        return response.data; // Return the server's response data
      }
    } catch (e) {
      rethrow;
    }
  }
}
