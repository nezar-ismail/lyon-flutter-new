import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lyon/api/api.dart';

class ApiService {
  Future<List<dynamic>> getTransportationRoutes({
    required String? token, 
    String type = 'car', 
    String mobile = '1'
  }) async {
    final response = await http.post(
      Uri.parse(ApiApp.getTransportationRoutes),
      body: {
        "token": token, 
        "type": type, 
        "mobile": mobile
      }
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transportation routes');
    }
  }

  Future<int> checkUserDocuments({required String? token}) async {
    final response = await http.post(
      Uri.parse(ApiApp.checkUserDocuments),
      body: {
        "token": token, 
        "mobile": "1"
      }
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check user documents');
    }
  }
}

