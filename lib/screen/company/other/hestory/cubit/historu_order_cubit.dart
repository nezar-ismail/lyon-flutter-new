import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lyon/model/company_model/get_orders_company_model.dart';
import 'package:meta/meta.dart';

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/api/api.dart';

part 'historu_order_state.dart';

class HistoryOrdersCubit extends Cubit<HistoryOrdersState> {
  HistoryOrdersCubit() : super(HistoryOrdersInitial());

  Future<void> fetchOrders() async {
    try {
      emit(HistoryOrdersLoading());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token_company');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final Map<String, String> requestBody = {
        "token": accessToken,
        "mobile": "1"
      };
      log(accessToken);

      final http.Response response = await http.post(
        Uri.parse(ApiApp.getCompanyOrders),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final orders = GetOrdersCompanyModel.fromJson(jsonResponse);
        emit(HistoryOrdersLoaded(orders));
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      emit(HistoryOrdersError(e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      final Map<String, String> requestBody = {"id": orderId, 'mobile': '1'};

      final http.Response response = await http
          .post(Uri.parse(ApiApp.deleteCompanyOrder), body: requestBody);

      final responseBody = jsonDecode(response.body);

      // Refetch orders after deletion
      await fetchOrders();
    } catch (e) {
      emit(HistoryOrdersError('Failed to delete order: ${e.toString()}'));
    }
  }
}
