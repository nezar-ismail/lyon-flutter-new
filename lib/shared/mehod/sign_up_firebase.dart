import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';

import 'package:lyon/v_done/utils/custom_log.dart';

class SignUpWithFirebase {
  Future<bool> signUp({
    required String emailAddress,
    required String password,
    required Map body,
  }) async {
    try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      logInfo("Email saved in Firebase sucessfully");
      await MethodAppApi()
          .methodPOSTSignUp(url: ApiApp.signUp, body: body);
      logInfo("Accound saved in DB successfully");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logWarning('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        logWarning('The account already exists for that email.');
        return false;
      }
    } catch (e) {
      logError(e.toString());
      return false;
    }
    return false;
  }


}
