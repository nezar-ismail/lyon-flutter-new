import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/other/details_tourist_program.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:lyon/v_done/utils/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TouristProgram extends StatefulWidget {
  final String image;
  final String price;
  final String type;
  const TouristProgram(
      {super.key,
      required this.image,
      required this.price,
      required this.type});
  @override
  State<TouristProgram> createState() => _TouristProgramState();
}

class _TouristProgramState extends State<TouristProgram> {
  late PageController _pageController;
  int count = 2;
  List<Map<String, dynamic>> ids = [];
  String result = '';
  List<Map<String, dynamic>> trips = [];
  var totalPrice = 0;
  var sumPrice = 0;
  List<TextEditingController> dateController =
      List.generate(12, (i) => TextEditingController());
  List<TextEditingController> timeController =
      List.generate(12, (i) => TextEditingController());
  bool isLaoding = true;
  List price = [];
  String? id;
  String? currency;
  bool isBtnSaved = false;
  bool isVisiblePassport = true;
  bool isVisiblePrice = false;
  bool isCheckTicket = false;
  bool isUploadTicketSuccess = false;
  bool isLoadingCreateOrder = false;
  bool ticket = false;
  List<String> locationsAr = [];
  List<String> locationsEn = [];
  var dates = [];
  Future<void> selectDate({
    required BuildContext context,
    required TextEditingController dateController,
    selectedDate,
    firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: DateTime((DateTime.now().year) + 3, 12),
        errorInvalidText: "Out of range");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
  }

  Future<void> selectTime(
      {required BuildContext context,
      required TextEditingController timeController}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      DateTime parsedTime =
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  List<String> locations = [];
  var prices = {};
  getTransportationRoutes() async {
    String apiUrl = ApiApp.getTransportationRoutes;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('access_token');
    http.Response response = await http.post(Uri.parse(apiUrl),
        body: {"token": token, "type": widget.type, "mobile": "1"});
    logInfo(' type ${widget.type}');
    logInfo(' response${jsonDecode(response.body)}');
    var jsonResponse = jsonDecode(response.body);
    for (var i = 0; i < jsonResponse.length; i++) {
      locationsAr
          .add("${jsonResponse[i]['start_ar']} - ${jsonResponse[i]['end_ar']}");
      logInfo('locations lengh${locations.length}');
      locationsEn
          .add("${jsonResponse[i]['start']} - ${jsonResponse[i]['end']}");
      prices[jsonResponse[i]["locations"]] = {};
      prices[jsonResponse[i]["locations"]]["carPrice"] =
          jsonResponse[i]["carPrice"];
      prices[jsonResponse[i]["locations"]]["vanPrice"] =
          jsonResponse[i]["vanPrice"];
      prices[jsonResponse[i]["locations"]]["coasterPrice"] =
          jsonResponse[i]["coasterPrice"];
      prices[jsonResponse[i]["locations"]]["busPrice"] =
          jsonResponse[i]["busPrice"];
      prices[jsonResponse[i]["locations"]]["requireTicket"] =
          jsonResponse[i]["requireTicket"];
      prices[jsonResponse[i]["locations"]]["id"] = jsonResponse[i]["id"];
      prices[jsonResponse[i]["locations"]]["currency"] =
          jsonResponse[i]["currency"];
      locations.add(jsonResponse[i]['locations']);
      logInfo('final locations$locations');
    }
  }

  checkUserDocuments() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": _sharedToken, "mobile": "1"};
    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _pageController = PageController();
    getTransportationRoutes().then((value) {
      if (mounted) {
        setState(() {
          isLaoding = false;
        });
      }
    });
    checkUserDocuments().then((value) {
      if (value == 2 || value == 3) {
        setState(() {
          isVisiblePassport = false;
        });
      } else {
        setState(() {
          isVisiblePassport = true;
        });
      }
    });
    super.initState();
  }

  void _nextPage() {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> json = {
        'Destination': "",
        'Date': "",
        'Time': "",
        'price': "",
        'requireTicket': ""
      };
      formKey.currentState!.save();
      if (_currentIndex < count - 1) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      } else if (_currentIndex == count - 1) {
        setState(() {
          if (count != 10) {
            count++;
            trips.add(json);
            _pageController.nextPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut);
          }
        });
      }
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (isLaoding == true) {
      return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('tourism_program'.tr,
              style: const TextStyle(color: Colors.white)),
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: secondaryColor1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomPaint(
                      painter: CircleLinkPainter(count),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          count,
                          (index) => Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  _pageController.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 80,
                                    padding: const EdgeInsets.all(2.5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                      border: Border.all(
                                          color: _currentIndex == index
                                              ? Colors.white
                                              : secondaryColor1),
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? secondaryColor1
                                          : Colors.grey.shade300,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: _currentIndex != index
                                              ? Colors.black
                                              : Colors.yellow,
                                        ),
                                        Text(
                                          '${'trip'.tr} ${index + 1}',
                                          style: TextStyle(
                                              color: _currentIndex == index
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    trips.isEmpty || index == trips.length
                                        ? '${"0".tr} ${currency ?? ""}'
                                        : "${trips[index]['price']}$currency ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Form(
                        key: formKey,
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemCount: count,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, i) {
                            return column(i);
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .25,
                              decoration: BoxDecoration(
                                  color: secondaryColor1,
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle),
                              child: Text(
                                textAlign: TextAlign.center,
                                'back'.tr,
                                style: const TextStyle(color: Colors.white),
                              )),
                          onPressed: _previousPage,
                        ),
                        Visibility(
                          visible: count > 2,
                          child: IconButton(
                            icon: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .25,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(0, 1))
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'delete'.tr,
                                  style: const TextStyle(color: Colors.white),
                                )),
                            onPressed: () {
                              if (count > 2) {
                                setState(() {
                                  count--;
                                  _currentIndex--;
                                  if (trips.isNotEmpty) {
                                    trips.removeAt(_currentIndex + 1);
                                  }
                                  _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.easeInOut);
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .25,
                              decoration: BoxDecoration(
                                color: secondaryColor1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                _currentIndex != count - 1 || _currentIndex == 0
                                    ? 'next'.tr
                                    : 'add_trip'.tr,
                                style: const TextStyle(color: Colors.white),
                              )),
                          onPressed: _nextPage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  minimumSize: const Size(50, 50),
                  maximumSize: const Size(150, 50),
                  elevation: 5,
                  foregroundColor: Colors.white,
                  backgroundColor: secondaryColor1,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
                ),
                onPressed: () async {
                  setState(() {
                    ids = [];
                    dates = [];
                    totalPrice = 0;
                    trips.removeWhere((trip) =>
                        trip['Destination'] == "" &&
                        trip['Date'] == "" &&
                        trip['Time'] == "" &&
                        trip['price'] == "" &&
                        trip['requireTicket'] == "");
                  });
                  if (trips.isEmpty) {
                    customSnackBar(
                        context, ''.tr, 'you_must_add_at_least_two_trips'.tr);
                  }
                  if (formKey.currentState!.validate() && trips.length >= 2) {
                    formKey.currentState!.save();
                    for (var i = 0; i < trips.length; i++) {
                      totalPrice = int.parse(trips[i]['price']) + totalPrice;
                      dates.add(trips[i]['requireTicket']);
                      if (dates.contains('1')) {
                        setState(() {
                          ticket = true;
                        });
                      } else {
                        setState(() {
                          ticket = false;
                        });
                      }
                    }
                    push(
                        context,
                        TouristProgramDetails(
                            trips: trips,
                            totalPrice: totalPrice,
                            currency: currency,
                            result: result,
                            image: widget.image,
                            vehicleType: widget.type,
                            ticket: ticket));
                  }
                },
                child: Text(
                  'continue'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
            ],
          ),
        ),
      );
    }
  }

  onUpdate(int entryIndex, String id, var pr, String requireTicket) {
    Map<String, dynamic> json = {
      'Destination': id,
      'Date': dateController[entryIndex].text,
      'Time': timeController[entryIndex].text,
      'price': pr,
      'requireTicket': requireTicket
    };

    ids.add(json);
    setState(() {
      result = jsonEncode(ids);
      logInfo("json: $json");
      if (trips.asMap().containsKey(entryIndex)) {
        return;
      } else {
        trips.add(json);
      }
    });
  }

  column(int index) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: width * .6,
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${'trip'.tr} ${index + 1}',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryColor1),
          ),
          Row(
            children: [
              Text(
                '${'destination'.tr} :',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: DropdownSearch<String>(
                  selectedItem: trips.isNotEmpty && index < trips.length
                      ? trips[index]['Destination']
                      : null,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null ? 'please_enter_destination'.tr : null,
                  items: locations,
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration:
                          InputDecoration(label: Text("select_location".tr))),
                  onChanged: (value) {
                    setState(() {
                      isVisiblePrice = true;
                      currency = prices[value]['currency'];
                      id = prices[value]['id'];
                    });
                    onUpdate(
                        index,
                        locationsEn[locations
                            .indexWhere((element) => element == value)],
                        prices[value][widget.price],
                        prices[value]['requireTicket']);
                  },
                  onSaved: (val) {
                    logInfo('locationsEn:$locationsEn');
                    onUpdate(
                        index,
                        locationsEn[
                            locations.indexWhere((element) => element == val)],
                        prices[val][widget.price],
                        prices[val]['requireTicket']);
                  },
                  filterFn: (instance, filter) {
                    if (instance.contains(filter)) {
                      return true;
                    } else if (instance
                        .toLowerCase()
                        .contains(filter.toLowerCase())) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${'date'.tr} :',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: textFieldWidgetWithoutFilledWithFunction(
                    context: context,
                    hintText: "pickup_date".tr,
                    controller: dateController[index],
                    icons: const Icon(
                      Icons.calendar_today,
                    ),
                    fun: () {
                      selectDate(
                        context: context,
                        dateController: dateController[index],
                        selectedDate: DateTime.now(),
                        firstDate: DateTime.now(),
                      );
                    },
                    textValidatorEmpty: "please_enter_date".tr),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${'Time'.tr} :',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: textFieldWidgetWithoutFilledWithFunctionSmall(
                  context: context,
                  fun: () {
                    selectTime(
                        context: context,
                        timeController: timeController[index]);
                  },
                  icons: const Icon(Icons.access_time),
                  controller: timeController[index],
                  hintText: "start_time".tr,
                  textValidatorEmpty: "please_enter_time".tr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleLinkPainter extends CustomPainter {
  final int count;

  CircleLinkPainter(this.count);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double spacing = size.width / count;
    for (int i = 0; i < count - 1; i++) {
      final startX = spacing * i + spacing / 2;
      final startY = size.height / 2;
      final endX = spacing * (i + 1) + spacing / 2;
      final endY = size.height / 2;

      // Draw a line between circles
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
