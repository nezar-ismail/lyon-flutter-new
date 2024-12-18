import 'dart:convert';
import 'dart:developer'; //(auto import will do this even)
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lyon/model/available_cars_model.dart';
import 'package:lyon/other/details_car.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/Widgets/appbar.dart';

class AvailableCars extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final firstTime;
  // ignore: prefer_typing_uninitialized_variables
  final firstDate;
  // ignore: prefer_typing_uninitialized_variables
  final endTime;
  // ignore: prefer_typing_uninitialized_variables
  final endDate;

  const AvailableCars({
    super.key,
    this.firstTime,
    this.firstDate,
    this.endTime,
    this.endDate,
  });

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  late Future<dynamic> futurePost;
  List<String?> carsName = [];
  List<int?> carsPrice = [];
  List<String?> carsImage = [];
  List<String?> carId = [];
  List<String?> currency = [];
  List<String?> gasolinType = [];
  bool noCarsAvaliable = false;
  @override
  void initState() {
    super.initState();
    // DateTime dateTime = DateTime.parse(widget.firstDate);
    //print(dateTime.day);
    // // TimeOfDayFormat timeFormat = TimeOfDayFormat.HH_colon_mm;
    // print(
    //     "${widget.firstDate.year}-${widget.firstDate.month}-${widget.firstDate.day}");

    // print(widget.firstDate);

    futurePost = postDateAndTime();

    futurePost.then((value) {
      if (value.data!.isEmpty) {
        setState(() {
          noCarsAvaliable = false;
        });
      }
      noCarsAvaliable
          ? value.data!.forEach((value) {
              carsName.add("${value.vehicleName} ${value.vehicleModel}");
              carId.add(value.carId.toString());
              carsPrice.add(value.price);
              currency.add(value.currency);
              gasolinType.add(value.type);
              carsImage.add('https://lyon-jo.com/${value.image}');
            })
          : null;
    });
  }

  Future postDateAndTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    String changeDate(String date) {
      var year = date.split('/')[0];
      var month = int.parse(date.split('/')[1]);
      var day = int.parse(date.split('/')[2]);
      return ("$year-${month <= 9 ? "0$month" : month}-${day <= 9 ? "0$day" : day}")
          .toString();
    }

    final json = {
      "startDate": changeDate(widget.firstDate),
      "startTime": widget.firstTime,
      "endDate": changeDate(widget.endDate),
      "endTime": widget.endTime,
      "token": sharedToken,
      "mobile": "1"
    };
    http.Response response = await http.post(
        Uri.parse("https://lyon-jo.com/api/availableCars.php"),
        body: json,
        encoding: Encoding.getByName("utf-8"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    var jsonResponse = jsonDecode(response.body);
    log(jsonResponse.toString());
    if (jsonResponse['status'] == 400 ||
        jsonResponse['status'] == 403 ||
        jsonResponse['status'] == 422) {
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("alert".tr),
              content: Text(
                jsonResponse['message'],
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                TextButton(
                  child: Text("ok".tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    if (jsonResponse['status'] == 404) {
      setState(() {
        noCarsAvaliable = false;
      });
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('alert'.tr),
              content: Text(
                jsonResponse['message'],
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                TextButton(
                  child: Text("ok".tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    if (jsonResponse['status'] == 200) {
      setState(() {
        noCarsAvaliable = true;
      });
      return AvailableCarsModle.fromJson(jsonResponse);
    }
  }
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: AppBars(
          text: "car available".tr,
          context: context,
          withIcon: false,
          canBack: true,
          endDrawer: true,
        ),
        body: FutureBuilder<dynamic>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () async {
                          // print("${wid
                          // get.firstDate}");
                          // print("${widget.}")
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeCap: StrokeCap.square,
                                    strokeWidth: 5,
                                  ),
                                );
                              });
                          push(
                              context,
                              DetailsCar(
                                  firstTime: widget.firstTime,
                                  endTime: widget.endTime,
                                  price: carsPrice[i],
                                  firstDate: widget.firstDate,
                                  carId: carId[i].toString(),
                                  lastDate: widget.endDate,
                                  carImage: carsImage[i]));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Text(carsName[i].toString())),
                                Flexible(
                                  flex: 3,
                                  child: Image.network(
                                    carsImage[i].toString(),
                                    // height: MediaQuery.of(context).size.height,
                                    // width: MediaQuery.of(context).size.width*.1,
                                  ),
                                ),
                                Text(
                                  gasolinType[i].toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width * .03,
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Text(
                                      '${carsPrice[i].toString()} ${currency[i].toString()}',
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Text('per_day'.tr),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5),
                                      color: secondaryColor1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Center(
                                      child: Text(
                                        'book'.tr,
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError || snapshot.data?.status == 0) {
                return Center(
                  child: Text(
                      "No Cars Available from \n${widget.firstDate} to ${widget.endDate}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
