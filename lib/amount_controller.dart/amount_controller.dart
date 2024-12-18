import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AmountController extends GetxController {
  int amount = 0;

  void setAmount(int newAmount) {
    amount = newAmount;
    update();
  }

  Future<bool> checkAmount() async {
    String? sharedToken;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    sharedToken = prefs.getString('access_token');
    try {
      var response = await http
          .post(Uri.parse('https://lyon-jo.com/api/checkBlacklist.php'), body: {
        'token': sharedToken,
      });
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        amount = jsonResponse["remainingAmount"];
        update();
        return true;
      } else {
        update();
        return false;
      }
    } catch (e) {
      update();

      return false;
    }
  }
}
