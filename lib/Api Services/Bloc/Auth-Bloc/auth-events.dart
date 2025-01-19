import 'dart:io';

abstract class AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNo;
  final String companyName;
  final String location;
  final String gender;
  final String govtIdProofNumber;
  final File govtIdPicture;
  final File profilePicture;
  final String userType;
  final String govtIdtype;

  RegisterUserEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNo,
    required this.companyName,
    required this.location,
    required this.gender,
    required this.govtIdProofNumber,
    required this.govtIdPicture,
    required this.profilePicture,
    required this.userType,
    required this.govtIdtype,
  });
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;

  LoginUserEvent(this.email, this.password);
}

class SendEmailOtpEvent extends AuthEvent {
  final String email;

  SendEmailOtpEvent({required this.email});
}

class SendMobileOtpEvent extends AuthEvent {
  final String mobileNo;
  SendMobileOtpEvent({required this.mobileNo});
}

class OtpVerifyEvent extends AuthEvent {
  final String email;
  final String mobile;
  final String channel;
  final String otp;
  OtpVerifyEvent(
    this.email,
    this.mobile,
    this.channel,
    this.otp,
  );
}
