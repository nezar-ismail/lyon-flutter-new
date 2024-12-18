import 'dart:io';

import 'package:lyon/api/api.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceProvider {
  static Future<String> loadAccountStatement(
      String dateFrom, String dateTo) async {
    const apiUrl = ApiApp.accountStatement;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');

    final json = {
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "token": sharedToken,
      "mobile": "1"
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    if (response.statusCode == 404) {
      return "404";
    }
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    logInfo(file.path);
    return file.path;
  }

  static Future<String> loadAccountStatementCompanies(
      String dateFrom, String dateTo, String projectName) async {
    const apiUrl = ApiApp.getCompanyAccountStatement;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token_company');

    final json = {
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "token": sharedToken,
      "mobile": "1",
      "projectName": projectName
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
}
