import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TripCheckOutController extends GetxController {
  RxBool displayTicketButton = true.obs;
  RxBool displayPassportButton = true.obs;
  RxBool displayThankfulMessageInTrip = false.obs;

  void toggleTicketVariable() {
    displayTicketButton.value = false;
  }

  void togglePassportVariable() {
    displayPassportButton.value = false;
  }

  Future<bool> checkIfUserInsertedPassport() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    print(_sharedToken);
    var response = await http.post(
      Uri.parse('https://lyon-jo.com/api/userDocuments.php'),
      body: {'token': _sharedToken},
    );
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print("jsonResponse of the tripCheckoutController: $jsonResponse");
    print("Here is the license value: ${jsonResponse['License']}");
    if (jsonResponse['status'] == 404) {
      return false;
    } else if (jsonResponse['ID/Passport'] == null) {
      return false;
    }
    displayPassportButton.value = false;
    return true;
  }
}
