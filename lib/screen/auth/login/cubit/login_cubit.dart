import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // Handle login
  void login({
    required String countryCode,
    required String phoneNumber,
    required String password,
    required int language,
  }) async {
    emit(LoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      final responseCode = await MethodAppApi().methodPOSTLogIn(
        url: ApiApp.logIn,
        body: {
          "countryCode": countryCode,
          "input": phoneNumber,
          "password": password,
          "mobile": "1",
          "token": await FirebaseMessaging.instance.getToken(),
          "language": language.toString(),
        },
      );

      if (responseCode == 200) {
        emit(LoginSuccess());
      } else if (responseCode == 102) {
        emit(LoginError("Phone does not exist!"));
      } else if (responseCode == 101) {
        emit(LoginError("Incorrect password!"));
      } else {
        emit(LoginError("Something went wrong! Please contact us."));
      }
    } catch (e) {
      emit(LoginError("An error occurred: ${e.toString()}"));
    }
  }
  // Change language
  void changeLanguage(int language) {
    emit(LanguageChanged(language));
  }

}
