import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutController extends GetxController {
  RxBool askUserForTicketUploading = true.obs;
  RxBool askUserForLicenseUploading = true.obs;
  RxBool askUserForPassportUploading = true.obs;
  RxBool licenseAndPassportAreAttached = false.obs;
  RxBool justDoneToSolveTheError = true.obs;
  RxBool displayAThankfulMessage = false.obs;
  RxBool theUserIsComingOrGoingToAirport = false.obs;

  void toggleLicenseVariableToFalse() {
    askUserForLicenseUploading.value = false;
  }

  void toggleTicketVariableToFalse() {
    askUserForTicketUploading.value = false;
  }

  void togglePassportVariableToFalse() {
    askUserForPassportUploading.value = false;
  }

  checkIfLicenseAndPassportAreAttached() async {
    String? apiResponse = await callTheUserDocumentsAPI();
    if (apiResponse == "Nothing attached") {
      licenseAndPassportAreAttached = false.obs;
    } else if (apiResponse == "All images are attached") {
      licenseAndPassportAreAttached = true.obs;
    } else if (apiResponse == "Ask user for license photo") {
      licenseAndPassportAreAttached = false.obs;
    } else if (apiResponse == "Ask user for passport photo") {
      licenseAndPassportAreAttached = false.obs;
    }
  }

  Future<String?> callTheUserDocumentsAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    var url = Uri.parse('https://lyon-jo.com/api/userDocuments.php');
    final json = {"token": sharedToken, "mobile": "1"};

    var response = await http.post(
      url,
      body: json,
    );

    String jsonsDataString = response.body
        .toString(); // toString of Response's body is assigned to jsonDataString
    var jsonResponse = jsonDecode(jsonsDataString);
    //var jsonResponse = jsonDecode(response.body.toString());

    if (jsonResponse['status'] == 404 ||
        (jsonResponse['status'] == 200 &&
            jsonResponse['Ticket'] == true &&
            jsonResponse['ID/Passport'] == null &&
            jsonResponse['License'] == null)) {
      return "Nothing attached";
    } else if (jsonResponse['status'] == 200 &&
        jsonResponse['documents'] == "all") {
      return "All images are attached";
    } else if (jsonResponse['status'] == 200 &&
        jsonResponse['License'] == null &&
        jsonResponse['ID/Passport'] != null) {
      return "Ask user for license photo";
    } else if (jsonResponse['status'] == 200 &&
        jsonResponse['ID/Passport'] == null &&
        jsonResponse['License'] != null) {
      return "Ask user for passport photo";
    } else if (jsonResponse['status'] == 200 &&
        jsonResponse['ID/Passport'] == true &&
        jsonResponse['License'] == true) {
      return "All images are attached";
    }
    return null;
  }

  checkTheControllerVariables() async {
    String? whatToDisplay = await callTheUserDocumentsAPI();
    if (whatToDisplay == "Nothing attached") {
      askUserForLicenseUploading.value = true;
      askUserForPassportUploading.value = true;
    } else if (whatToDisplay == "All images are attached") {
      askUserForLicenseUploading.value = false;
      askUserForPassportUploading.value = false;
    } else if (whatToDisplay == "Ask user for license photo") {
      askUserForLicenseUploading.value = true;
      askUserForPassportUploading.value = false;
    } else if (whatToDisplay == "Ask user for passport photo") {
      askUserForLicenseUploading.value = false;
      askUserForPassportUploading.value = true;
    }
  }
}
