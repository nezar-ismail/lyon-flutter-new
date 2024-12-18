// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:lyon/api/api.dart';

import 'package:lyon/model/offers_model.dart';
import 'package:lyon/screen/auth/signup/sigup_page.dart';
import 'package:lyon/other/rental.dart';
import 'package:lyon/other/select_one_trip.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';

// ignore: must_be_immutable
class Offer extends StatefulWidget {
  bool? isGuest;
  Offer({
    super.key,
    this.isGuest,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  late Future<OfferModel> futurePost;

  Future<OfferModel> getOffers() async {
    String apiUrl = ApiApp.getOffers;

    http.Response response = await http.get(Uri.parse(apiUrl));

    var jsonResponse = jsonDecode(response.body);
    return OfferModel.fromJson(jsonResponse);
  }

  @override
  void initState() {
    futurePost = getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: FutureBuilder<OfferModel>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: MediaQuery.of(context).size.height / 9,
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 0);
                },
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, i) {
                  // return Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: Center(
                  //     child: Stack(
                  //       children: [
                  //         Container(

                  //           child: Center(
                  //               child: Padding(
                  //             padding: const EdgeInsets.all(18.0),
                  //             child: CustomText(
                  //               text: snapshot.data!.data[i].body.toString(),
                  //               color: const Color(0xFFffdd00),
                  //               alignment: Alignment.bottomCenter,
                  //               size: 20,
                  //               maxLine: 3,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           )),
                  //           width: _width * .9,
                  //           height: _height / 4,
                  //           decoration: BoxDecoration(
                  //               borderRadius: const BorderRadius.only(
                  //                 bottomLeft: Radius.circular(50.0),
                  //                 topRight: Radius.circular(50.0),
                  //               ),
                  //               color: Colors.black,
                  //               image: DecorationImage(
                  //                   image: NetworkImage(
                  //                     snapshot.data!.data![i].image.toString(),
                  //                   ),
                  //                   fit: BoxFit.fill)),
                  //         ),
                  //         // Container(
                  //         //   width: _width * .9,
                  //         //   height: _height / 4,
                  //         //   decoration: BoxDecoration(
                  //         //     image: DecorationImage(
                  //         //       image: NetworkImage(
                  //         //           snapshot.data!.data![i].image.toString()),
                  //         //       fit: BoxFit.fill,
                  //         //     ),
                  //         //     color: Colors.black,
                  //         // borderRadius: BorderRadius.only(
                  //         //   bottomLeft: Radius.circular(50.0),
                  //         //   topRight: Radius.circular(50.0),
                  //         // ),
                  //         //   ),
                  //         // ),
                  //         // Positioned(
                  //         //     top: 90,
                  //         //     right: 30,
                  //         //     child: CustomText(
                  //         //       text: snapshot.data!.data![i].text.toString(),
                  //         //       color: Colors.white,
                  //         //       size: 20,
                  //         //       fontWeight: FontWeight.bold,
                  //         //     ))

                  //         // Positioned(
                  //         //   child: Container(
                  //         //     width: _width * .25,
                  //         //     height: _height / 8,
                  //         //     decoration: BoxDecoration(
                  //         //       color: Colors.grey.shade300,
                  //         //       shape: BoxShape.circle,
                  //         //     ),
                  //         //     child: Column(
                  //         //       mainAxisAlignment: MainAxisAlignment.center,
                  //         //       children: [
                  //         //         CustomText(
                  //         //           text: 'offer'.tr,
                  //         //           alignment: Alignment.center,
                  //         //           size: 25,
                  //         //           fontWeight: FontWeight.bold,
                  //         //         ),
                  //         //         Row(
                  //         //           mainAxisAlignment: MainAxisAlignment.center,
                  //         //           children: const [
                  //         //             CustomText(
                  //         //               text: '50%',
                  //         //               size: 20,
                  //         //               alignment: Alignment.center,
                  //         //             ),
                  //         //             Icon(Icons.local_offer_outlined),
                  //         //           ],
                  //         //         )
                  //         //       ],
                  //         //     ),
                  //         //   ),
                  //         //   top: 0.0,
                  //         //   right: 0.0,
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if (snapshot.data!.data[i].title
                                      .toString()
                                      .trim()
                                      .toLowerCase() ==
                                  "car rental") {
                                if (widget.isGuest == true) {
                                  push(context, const SignupPage());
                                } else {
                                  push(context, const Rental());
                                }
                              } else if (snapshot.data!.data[i].title
                                          .toString() ==
                                      "Trip" ||
                                  snapshot.data!.data[i].title
                                          .toString()
                                          .toLowerCase() ==
                                      "trip") {
                                if (widget.isGuest == true) {
                                  push(context, const SignupPage());
                                } else {
                                  push(context, const SelectOneTrip());
                                }
                              }
                            },
                            child: Card(
                              elevation: 20,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: height * .012,
                                    bottom: height * .012,
                                    left: width * .03,
                                    right: width * .03),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: snapshot.data!.data[i].title
                                                  .toString()
                                                  .trim()
                                                  .toLowerCase() ==
                                              'trip'
                                          ? const EdgeInsets.only(bottom: 10.0)
                                          : const EdgeInsets.only(bottom: 0.0),
                                      child: Text(
                                        snapshot.data!.data[i].title.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * .8,
                                      height: height / 5,
                                      decoration: BoxDecoration(
                                          // borderRadius: const BorderRadius.only(
                                          //   bottomLeft: Radius.circular(50.0),
                                          //   topRight: Radius.circular(50.0),
                                          // ),
                                          //color: Colors.red,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                snapshot.data!.data[i].image
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill)),
                                    ),
                                    Divider(
                                      endIndent: width * .001,
                                      thickness: 0.75,
                                    ),
                                    Center(
                                      child: Text(
                                        snapshot.data!.data[i].body.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            wordSpacing: -1.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: CustomText(
                text: 'no_offers_available'.tr,
                size: 20,
                fontWeight: FontWeight.bold,
                alignment: Alignment.center,
              ),
            );
          }
        },
      ),
    );
  }
}
