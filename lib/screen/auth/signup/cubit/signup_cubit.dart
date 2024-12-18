import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/model/error_model.dart';
import 'package:lyon/screen/auth/signup/cubit/signup_state.dart';
import 'package:lyon/shared/mehod/otp_verification.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  String selectedCountryCode = "US"; // Default ISO Code
  String phoneNumber = "";

  void updatePhoneNumber(String phone) {
    phoneNumber = phone;
    emit(SignupInitial()); // Emit state to notify UI if necessary
  }

  void updateSelectedCountryCode(String isoCode) {
    selectedCountryCode = isoCode;
    emit(SignupInitial()); // Emit state to notify UI if necessary
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String countryCode,
    required String phone,
    required String email,
    required String password,
    required String birthdate,
    required String currency,
  }) async {
    try {
      emit(SignupLoading());

      // Get FCM Token
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) throw Exception("Failed to retrieve FCM token");

      // Prepare request body
      Map<String, String> bodySignUp = {
        "firstName": firstName,
        "lastName": lastName,
        "countryCode": countryCode,
        "phone": phone,
        "email": email,
        "password": password,
        "birthdate": birthdate,
        "token": token,
        "currency": currency,
        "mobile": "1"
      };
      logInfo("bodySignUp ${bodySignUp.toString()}");

      // Phone validation
      if (phone.length < 9) {
        emit(SignupError("Phone number is not valid"));
        return;
      }

      // Duplicate check
      emit(DuplicateCheckInProgress());
      var response = await http.post(
        Uri.parse(ApiApp.checkDuplicates),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"countryCode": countryCode, "phone": phone, "email": email},
      );

      var responseBody = jsonDecode(response.body);
      var isDuplicates = ErrorCheck.fromJson(responseBody);

      if (isDuplicates.status != 200) {
        emit(DuplicateCheckFailed(isDuplicates.error.toString()));
        return;
      }

      // Save data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("name", "$firstName $lastName");
      prefs.setString("email", email);
      prefs.setString("access_token", token);

      // Proceed with OTP verification
      var otpResponse = await OtpVerification().sendOTP(email, 0);
      if (!otpResponse) throw Exception("Failed to send OTP");

      // Success
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupError("Error: $e"));
    }
  }
}
