import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/company_model/trips_model.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/api.dart';
import '../../../shared/Widgets/custom_text.dart';
import '../../../shared/styles/colors.dart';
import '../../../v_done/company/history/history_orders_company.dart';

class DetailsMultiTripCompany extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Trips mapMobile;
  // ignore: prefer_typing_uninitialized_variables
  final totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final vechileType;
  // ignore: prefer_typing_uninitialized_variables
  final name;
  // ignore: prefer_typing_uninitialized_variables
  final phone;
  // ignore: prefer_typing_uninitialized_variables
  final projectName;
  const DetailsMultiTripCompany(
      {super.key,
      required this.mapMobile,
      this.totalPrice,
      this.vechileType,
      this.name,
      this.projectName,
      this.phone});

  @override
  State<DetailsMultiTripCompany> createState() =>
      _DetailsMultiTripCompanyState();
}

class _DetailsMultiTripCompanyState extends State<DetailsMultiTripCompany> {
  bool isLoading = false;
  num totalPrice = 0;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    for (var i = 0; i < widget.mapMobile.list.length; i++) {
      totalPrice = totalPrice + widget.mapMobile.list[i].price!;
    }
    super.initState();
  }

  @override
  dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        centerTitle: true,
        title: const Text(
          "Details",
        ),
      ),
      body: isLoading == true
          ? const Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : ListView(
              children: [
                SizedBox(
                  height: _height * .03,
                ),
                Center(
                    child: Image.asset(
                        widget.vechileType == 'Car'
                            ? 'assets/images/camry2.png'
                            : 'assets/images/van2.png',
                        width: _width / 2)),
                SizedBox(
                  height: _height * .03,
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.mapMobile.list.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              
                              child: Text(
                                widget.mapMobile.list[i].destination.toString(),
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                                '${widget.mapMobile.list[i].price} ${widget.mapMobile.list[i].currency}'),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.mapMobile.list[i].date!),
                                Text(widget.mapMobile.list[i].time.toString()),
                                Text(widget.mapMobile.list[i].location!),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.mapMobile.list[i].customerName!,
                                  style:
                                      const TextStyle(color: secondaryColor1),
                                ),
                                Text(
                                  widget.mapMobile.list[i].phoneNumber
                                      .toString(),
                                  style:
                                      const TextStyle(color: secondaryColor1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: secondaryColor1,
                          child: Text('${i + 1}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }),
                SizedBox(
                  height: _height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'total_price'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: _width * .1,
                      ),
                      Text(
                        '$totalPrice ${widget.mapMobile.list[0].currency}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: SizedBox(
                      width: _width * 0.5,
                      height: _height * 0.06,
                      // ignore: deprecated_member_use
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () async {
                          if (totalPrice == 0) {
                            showMessage(
                                context: context,
                                text: 'a_network_error_has_occurred'.tr);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            var _sharedToken =
                                _prefs.getString('access_token_company');
                            Map<String, dynamic> json = {
                              'list': jsonEncode(widget.mapMobile.list),
                              'phone': widget.mapMobile.list[0].phoneNumber,
                              'name': widget.mapMobile.list[0].customerName,
                              'startTime': widget.mapMobile.list[0].time,
                              'startDate': widget.mapMobile.list[0].date,
                              'vechileType': widget.vechileType,
                              'token': _sharedToken,
                              'mobile': '1',
                              'totalPrice': totalPrice.toString(),
                              'projectName': widget.projectName
                            };

                            String apiUrl = ApiApp.addCompanyOrder;
                            http.Response response = await http
                                .post(Uri.parse(apiUrl), body: json)
                                .whenComplete(() => setState(() {
                                      isLoading = false;
                                    }));

                            var jsonResponse = jsonDecode(response.body);
                            showMessage(
                                context: context,
                                text: jsonResponse['message']);
                            push(context, const HistoryOrdersCompany());
                          }
                        },
                        child: CustomText(
                          alignment: Alignment.center,
                          text: 'submit'.tr,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
