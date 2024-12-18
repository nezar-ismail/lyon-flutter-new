import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MethodAppApi {
  late SharedPreferences sharedPreferences;

  Future<int> methodPOSTLogIn({required String url, required Map body}) async {
    int status = 0;
    String name;
    String email;
    String token;
    var response = await http.post(Uri.parse(url), body: body);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      name = responseBody["name"] ?? '';
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("name", name);
      email = responseBody["email"] ?? "";
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("email", email);
      status = responseBody["status"];
      token = responseBody["token"] ?? "";
      sharedPreferences.setString("access_token", token);
    }
    return status;
  }

  Future<int> methodPOSTReturnString(
      {required String url, required Map body}) async {
    int status = 0;
    var response = await http.post(Uri.parse(url), body: body);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      status = responseBody["status"];
    }
    return status;
  }

  Future<int> methodPOSTSignUp({required String url, required Map body}) async {
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body);
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody["status"];
  }

  Future<bool> methodPOST({required String url, required Map body}) async {
    var response = await http.post(Uri.parse(url), body: body);
    // var responseB/ody = jsonDecode(response.body);
    if (response.statusCode == 200) {}
    return true;
  }

  Future methodPOSTReturnResponse(
      {required String url, required Map body, Map? headers}) async {
    var response = await http.post(Uri.parse(url), body: body);
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Future<String> methodPOSTCheckDuplicates(
      {required String url, required Map body}) async {
    var response = await http.post(Uri.parse(url), body: body);

    var responseBody = jsonDecode(response.body);
    String statue = responseBody["error"];
    return statue;
  }
}
