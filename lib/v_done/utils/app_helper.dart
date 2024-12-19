import 'dart:convert';
import 'dart:ui';
import 'package:in_app_review/in_app_review.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/api/api.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHelper {
  static Future<void> reviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      Future.delayed(const Duration(seconds: 2), () {
        inAppReview.requestReview();
      });
    }
  }

  static Future<void> checkBlackList({
    required VoidCallback onLoadingComplete,
    required Function(String blacklist, int remainingAmount) onSuccess,
  }) async {
    String apiUrl = ApiApp.checkBlacklist;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    final json = {"token": sharedToken, "mobile": "1"};

    try {
      http.Response response = await http.post(Uri.parse(apiUrl), body: json);
      onLoadingComplete();

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] == 200) {
        onSuccess(jsonResponse['blacklist'], jsonResponse['remainingAmount']);
      }
    } catch (e) {
      onLoadingComplete();
      logError(e.toString());
      rethrow;
    }
  }
}
