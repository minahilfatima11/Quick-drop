abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSendingState extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final dynamic data;

  AuthRegisterSuccess(this.data);
}

class AuthLoginSuccess extends AuthState {
  final dynamic data;

  AuthLoginSuccess(this.data);
}

class AuthOtpSendState extends AuthState {
  final dynamic data;

  AuthOtpSendState(this.data);
}

class AuthOtpVerifyState extends AuthState {
  final dynamic data;

  AuthOtpVerifyState(this.data);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
