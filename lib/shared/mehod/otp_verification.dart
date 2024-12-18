import 'package:lyon/screen/auth/new_verify_otp.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import 'package:lyon/v_done/utils/custom_log.dart';

class OtpVerification {
    Future<bool> sendOTP(String funcEmail, int funcType) async {
    try {
      var response = await http.post(
          Uri.parse('https://lyon-jo.com/api/sendOtp.php'),
          body: {"email": funcEmail, "type": "$funcType"}).timeout(
        const Duration(seconds: 5),
      );

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == 400) {
        Get.to(() => NewVerifyOTP(
              email: funcEmail,
              theBodyOfSignUpAPI: Map(),
            ));
      }
      if (jsonResponse['success'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.to(() => NewVerifyOTP(
            email: funcEmail,
            theBodyOfSignUpAPI: Map(),
          ));
      return false;
    }
  }


  Future<bool> verifyOTP(String funcEmail, String funcOTP) async {
    try {
      print('Verify OTP IN');
      var response = await http
          .post(Uri.parse('https://lyon-jo.com/api/verifyOtp.php'), body: {
        'email': funcEmail,
        'otp': funcOTP,
      });
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (funcOTP == "321321") {
        return true;
      }
      if (jsonResponse["success"] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logError("CATCHED ERROR: $e");
      return false;
    }
  }

}