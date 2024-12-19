// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
import '../../../shared/Widgets/custom_text.dart';
import '../../../shared/mehod/message.dart';
import '../../../shared/mehod/switch_sreen.dart';
import '../../../shared/styles/colors.dart';
import '../../../v_done/company/history/history_orders_company.dart';

class DetailsOneTripCompany extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final mapMobile;
  // ignore: prefer_typing_uninitialized_variables
  final totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final vechileType;
  // ignore: prefer_typing_uninitialized_variables
  final itemCount;
  // ignore: prefer_typing_uninitialized_variables
  final phone;
  // ignore: prefer_typing_uninitialized_variables
  final name;
  // ignore: prefer_typing_uninitialized_variables
  final projectName;
  // ignore: prefer_typing_uninitialized_variables
  final webJson;
  const DetailsOneTripCompany(
      {super.key,
      this.projectName,
      this.mapMobile,
      this.totalPrice,
      this.vechileType,
      this.itemCount,
      this.phone,
      this.name,
      this.webJson});

  @override
  State<DetailsOneTripCompany> createState() => _DetailsOneTripCompanyState();
}

class _DetailsOneTripCompanyState extends State<DetailsOneTripCompany> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        centerTitle: true,
        title: Text(
          "details".tr,
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
                  height: height * .03,
                ),
                Center(
                    child: Image.asset(
                        widget.vechileType == 'Car'
                            ? 'assets/images/camry2.png'
                            : 'assets/images/van2.png',
                        width: width / 2)),
                SizedBox(
                  height: height * .03,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * .03,
                    ),
                    Text('destination'.tr + ' : '.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(widget.mapMobile['Destination'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: height * .01,
                ),
                widget.mapMobile['Location'] == 'Multi Location Way'
                    ? Container()
                    : Row(
                        children: [
                          SizedBox(
                            width: width * .03,
                          ),
                          Text('location'.tr + ' : '.tr,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(widget.mapMobile['Location'],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                SizedBox(
                  height: height * .03,
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.itemCount,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('date'.tr +
                                ' : '.tr +
                                widget.mapMobile['Date'][i].toString()),
                            const Text('/'),
                            Text('time'.tr +
                                ' : '.tr +
                                widget.mapMobile['Time'][i].toString()),
                            const Text('/'),
                            Text(
                                '${widget.mapMobile['price']} ${widget.mapMobile['currency']}'),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: secondaryColor1,
                          child: Text('${i + 1}'),
                        ),
                      );
                    }),
                SizedBox(
                  height: height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'total_price'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: width * .1,
                      ),
                      Text(
                        '${widget.totalPrice} ${widget.mapMobile['currency']}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: SizedBox(
                      width: width * 0.5,
                      height: height * 0.06,
                      // ignore: deprecated_member_use
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var sharedToken =
                              prefs.getString('access_token_company');
                          Map<String, dynamic> json = {
                            'list': jsonEncode(widget.webJson),
                            'phone': '0000',
                            'startTime': widget.webJson[0]['Time'],
                            'startDate': widget.webJson[0]['Date'],
                            'name': widget.name,
                            'vechileType': widget.vechileType,
                            'token': sharedToken,
                            'mobile': '1',
                            'totalPrice': widget.totalPrice.toString(),
                            // 'numberOfTrips': widget.itemCount.toString(),
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
                              context: context, text: jsonResponse['message']);
                          push(context, const HistoryOrdersCompany());
                        },
                        child: CustomText(
                          alignment: Alignment.center,
                          text: 'submit'.tr,
                          color: Colors.white,
                          size: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
