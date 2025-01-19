import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zipline_project/Api%20Services/Repository/auth_repo.dart';

import 'auth-events.dart';
import 'auth-state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
    on<SendEmailOtpEvent>(_onEmailOtpSend);
    on<SendMobileOtpEvent>(_onMobileOtpSend);
    on<OtpVerifyEvent>(_onVerifyOtp);
  }

  void _onRegisterUser(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await authRepo.register(
          name: event.name,
          email: event.email,
          password: event.password,
          phoneNo: event.phoneNo,
          companyName: event.companyName,
          location: event.location,
          gender: event.location,
          govtIdProofNumber: event.govtIdProofNumber,
          govtIdPicture: event.govtIdPicture,
          profilePicture: event.profilePicture,
          userType: event.userType,
          govtProofType: event.govtIdtype);
      emit(AuthRegisterSuccess(result));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onLoginUser(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await authRepo.login(event.email, event.password);

      if (result["code"] == "0") {
        emit(AuthLoginSuccess(result));
      } else {
        emit(AuthFailure(result["message"]));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onEmailOtpSend(SendEmailOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpSendingState());
    try {
      var data = await authRepo.SendEmailOtp(event.email);
      emit(AuthOtpSendState(data));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onMobileOtpSend(
      SendMobileOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpSendingState());
    try {
      var data = await authRepo.SendMobileOtp(event.mobileNo);
      emit(AuthOtpSendState(data));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onVerifyOtp(OtpVerifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var data = await authRepo.verifyOtp(
          event.mobile, event.email, event.channel, event.otp);
      emit(AuthOtpVerifyState(data));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
