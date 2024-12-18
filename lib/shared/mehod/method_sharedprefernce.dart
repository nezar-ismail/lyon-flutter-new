import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('access_token').toString();

  return token;
}

removeSharedPreference() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // String? token = sharedPreferences.getString('access_token');
  //await sharedPreferences.clear();

  sharedPreferences.remove('access_token');
  sharedPreferences.remove('isCompanyLoggedIn');
  sharedPreferences.remove('company_name');
  sharedPreferences.remove('access_token_company');
  sharedPreferences.remove('withRental');
  sharedPreferences.remove('withTrip');
  sharedPreferences.remove('withFullDay');

  // ignore: avoid_print
  print('Remove Success');
}
