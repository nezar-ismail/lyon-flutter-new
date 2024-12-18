import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TourismCheckOutController extends GetxController {
  RxBool displayPassportButton = true.obs;
  RxBool displayTicketButton = true.obs;

  void togglePassportVariableToFalse() {
    displayPassportButton.value = false;
  }

  void toggleTicketVariableToFalse() {
    displayTicketButton.value = false;
  }

  Future<bool> checkIfPassportInserted() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    print(_sharedToken);
    var response = await http.post(
      Uri.parse('https://lyon-jo.com/api/userDocuments.php'),
      body: {'token': _sharedToken},
    );
    var jsonResponse = jsonDecode(response.body);
    print("jsonResponse of the tripCheckoutController: $jsonResponse");
    print("Here is the license value: ${jsonResponse['License']}");
    if (jsonResponse['status'] == 404) {
      displayPassportButton.value = true;

      return false;
    } else if (jsonResponse['ID/Passport'] == null) {
      displayPassportButton.value = true;

      return false;
    }
    displayPassportButton.value = false;
    return true;
  }
}
