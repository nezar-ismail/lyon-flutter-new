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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    var response = await http.post(
      Uri.parse('https://lyon-jo.com/api/userDocuments.php'),
      body: {'token': sharedToken},
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 404) {
      return false;
    } else if (jsonResponse['ID/Passport'] == null) {
      return false;
    }
    displayPassportButton.value = false;
    return true;
  }
}
