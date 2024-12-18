import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:get/get.dart';
import 'package:lyon/screen/company/other/account_statement_date_company.dart';
import 'package:lyon/screen/company/trip_company/choose_trip.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/mehod/message.dart';
import '../../../shared/mehod/method_sharedprefernce.dart';
import '../../../shared/styles/colors.dart';
import '../../auth/login/login_page.dart';
import '../full_day_company/full_day_program_company.dart';
import 'hestory/history_orders_company.dart';
import '../rental_company/rental_available_company.dart';
import 'settings_company.dart';

// ignore: must_be_immutable
class HomePageCompany extends StatefulWidget {
  bool? withRental;
  bool? withTrip;
  bool? withfullDay;
  HomePageCompany(
      {super.key, this.withRental, this.withTrip, this.withfullDay});

  @override
  State<HomePageCompany> createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany> {
  String companyName = '';
  bool withRental = true;
  bool withTrip = true;
  bool withFullDay = true;
  companyNameSharedPre() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      companyName = sharedPreferences.getString("company_name")!;
      withRental = sharedPreferences.getBool("withRental")!;
      withTrip = sharedPreferences.getBool("withTrip")!;
      withFullDay = sharedPreferences.getBool("withFullDay")!;
    });
  }

  @override
  void initState() {
    companyNameSharedPre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor1,
            title: const Text(
              'LYON',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  showPopup(
                      context: context,
                      funAccept: () {
                        removeSharedPreference();
                        pushAndRemoveUntil(context, LogInScreen());
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      },
                      funReject: () {
                        Navigator.pop(context);
                      },
                      question: "are_you_sure_to_exit".tr);
                },
                icon: const Icon(Icons.logout)),
            actions: [
              IconButton(
                  onPressed: () {
                    push(context, const SettingsCompany());
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1 / 2,
              ),
              Text(
                companyName.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1 / 2,
              ),
              Expanded(
                  child: GridView.count(
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  if (withRental)
                    GestureDetector(
                        onTap: () {
                          push(context, const RentalAvailableCompany());
                        },
                        child: InnerShadow(
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(.3),
                                offset: const Offset(10, 5),
                                blurRadius: 10,
                              ),
                            ],
                            child: Image.asset(
                                'assets/images/rentalCompany.png'))),
                  if (withTrip)
                    GestureDetector(
                        onTap: () {
                          push(context, const ChooseTrip());
                        },
                        child: InnerShadow(
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(.3),
                                offset: const Offset(10, 5),
                                blurRadius: 10,
                              ),
                            ],
                            child:
                                Image.asset('assets/images/tripCompany.png'))),
                  if (withFullDay)
                    GestureDetector(
                        onTap: () {
                          push(context, const FullDayProgramCompany());
                        },
                        child: InnerShadow(shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(.3),
                            offset: const Offset(10, 5),
                            blurRadius: 10,
                          ),
                        ], child: Image.asset('assets/images/full_day.png'))),
                  GestureDetector(
                      onTap: () {
                        push(context, const HistoryOrdersCompany());
                      },
                      child: InnerShadow(
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(.3),
                              offset: const Offset(10, 5),
                              blurRadius: 10,
                            ),
                          ],
                          child:
                              Image.asset('assets/images/myOrderCompany.png'))),
                  GestureDetector(
                    onTap: () {
                      push(
                          context,
                          AccountStatementDateCompany(
                            accountType: 'company',
                          ));
                    },
                    child: InnerShadow(shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(.3),
                        offset: const Offset(10, 5),
                        blurRadius: 10,
                      ),
                    ], child: Image.asset('assets/images/AcnCompany.png')),
                  )
                ],
              )),
            ],
          )),
    );
  }
}
