import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
part 'trip_form_state.dart';

class TripProgramCubit extends Cubit<TripFormState> {
  TripProgramCubit() : super(TripFormInitial());

  List<String> destinationList = ["Loading.......".tr];
  String destenation = '';
  String type = '';
  int price = 0;
  String currency = '';

  Future<void> getTripsDestination() async {
    emit(TripFormLoading());
    try {
      String apiUrl = ApiApp.getAllCompanyTransportations;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('access_token_company');
      http.Response response = await http
          .post(Uri.parse(apiUrl), body: {"token": token, "mobile": "1"});
      var jsonResponse = jsonDecode(response.body);
      destinationList.clear();
      for (var i = 0; i < jsonResponse.length; i++) {
        destinationList.add(jsonResponse[i]['location']);
      }
      emit(GetTripsDestinationSuccess(destinationList: destinationList));
    } on Exception catch (e) {
      emit(GetTripsDestinationFailure(message: e.toString()));
    }
  }

  void updateDestination(String finalDestination) {
    destenation = finalDestination;
  }

  void updateType(String type) {
    destenation = type;
  }

  void goToProgram() {
    emit(GoToProgram());
  }

  Future<void> getTripPrice(
      String vehicleType, String type, String destenation) async {
    emit(GetTripsPriceLoading());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sharedToken = prefs.getString('access_token_company');
      String apiUrl = ApiApp.getTotalTransportationOrder;
      var body = {
        'destination': destenation,
        'trips': type,
        'vehicleType': vehicleType,
        'numberOfTrips': '1',
        'token': sharedToken,
        'mobile': '1'
      };
      http.Response response = await http.post(Uri.parse(apiUrl), body: body);
      var jsonResponse = jsonDecode(response.body);
      price = jsonResponse['totalPrice'];
      currency = jsonResponse['currency'];
      logInfo('prices >>>>>>>>>>>>> $jsonResponse');
      
      emit(GetTripsPriceSuccess(
          price: jsonResponse['totalPrice'].toString(),
          currency: jsonResponse['currency'].toString()));

      logInfo('prices >>>>>>>>>>>>> $jsonResponse');
      logWarning(body.toString());
    } on Exception catch (e) {
      emit(GetTripsPriceFailure(message: e.toString()));
    }
  }
}
