
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyon/other/user_trip_program/api/api_service.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'tourist_program_state.dart';

class TouristProgramCubit extends Cubit<TouristProgramState> {
  final ApiService apiService;

  TouristProgramCubit({required this.apiService})
      : super(TouristProgramInitial()) {
    initialize();
  }

  Future<void> initialize() async {
    await loadTransportationRoutes();
    await checkUserDocuments();
  }

  Future<void> loadTransportationRoutes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await apiService.getTransportationRoutes(token: token);

      List<String> locationsAr = [];
      List<String> locationsEn = [];
      List<Map<String, dynamic>> locations = [];

      for (int i = 0; i < response.length; i++) {
        locationsAr
            .add("${response[i]['start_ar']} - ${response[i]['end_ar']}");
        locationsEn.add("${response[i]['start']} - ${response[i]['end']}");

        locations.add({
          'detination': LocalizationService().getCurrentLang() == 'Arabic'
              ? "${response[i]['start_ar']} - ${response[i]['end_ar']}"
              : "${response[i]['start']} - ${response[i]['end']}",
          'carPrice': response[i]['carPrice'],
          'vanPrice': response[i]['vanPrice'],
          'coasterPrice': response[i]['coasterPrice'],
          'busPrice': response[i]['busPrice'],
          'requireTicket': response[i]['requireTicket'],
          'id': response[i]['id'],
          'currency': response[i]['currency'],
        });
      }

      emit(LoadTransportationRoutesSuccess(
        locations,
        LocalizationService().getCurrentLang() == 'Arabic'
            ? locationsAr
            : locationsEn,
      ));
    } catch (e) {
      logError('Error loading transportation routes: $e');
    }
  }

  bool isVisiblePassport = true;
  Future<void> checkUserDocuments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await apiService.checkUserDocuments(token: token);

      isVisiblePassport = response != 2 && response != 3;
    } catch (e) {
      logError('Error checking user documents: $e');
    }
  }
}
