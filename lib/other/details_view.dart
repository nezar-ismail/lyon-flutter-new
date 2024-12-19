import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/get_cars_details_model.dart';
import '../api/api.dart';
import '../shared/styles/colors.dart';

class DetailsView extends StatefulWidget {
  final int? id;
  const DetailsView({super.key, this.id});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late Future<GetCarsDetailsModel> futurePost;

  Future<GetCarsDetailsModel> getCarDetails() async {
    String apiUrl = ApiApp.getCarDetails;
    final json = {"id": widget.id.toString(), "mobile": "1"};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    return GetCarsDetailsModel.fromJson(jsonResponse);
  }

  @override
  void initState() {
    futurePost = getCarDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        title: Text("details".tr),
      ),
      body: FutureBuilder<GetCarsDetailsModel>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * .01,
                  ),
                  Text(
                    snapshot.data!.data!.name.toString(),
                    style: styleBlack25WithBold,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  SizedBox(
                    height: height / 5,
                    width: width,
                    child: CarouselSlider.builder(
                      unlimitedMode: true,
                      autoSliderDelay: const Duration(seconds: 3),
                      keepPage: true,
                      enableAutoSlider: true,
                      slideTransform: const DefaultTransform(),
                      autoSliderTransitionTime: const Duration(seconds: 2),
                      itemCount: snapshot.data!.imageCount!.toInt(),
                      slideBuilder: (index) => Image.network(
                        'https://lyon-jo.com/${snapshot.data!.data!.images![index]}',
                        width: double.infinity,
                        height: height / 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Text(
                    'internal_specifications'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  SizedBox(
                    width: width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: snapshot.data!.data!.internalSpecifications!
                          .map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 05,
                                  backgroundColor: Color(0xffC4C4C4)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                item,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    color: const Color(0xffC4C4C4),
                    height: height * .003,
                    width: width * .7,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Text(
                    'safety_features'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  SizedBox(
                    width: width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children:
                          snapshot.data!.data!.safetyFeatures!.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 05,
                                  backgroundColor: Color(0xffC4C4C4)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                item,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    color: const Color(0xffC4C4C4),
                    height: height * .003,
                    width: width * .7,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Text(
                    'features'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  SizedBox(
                    width: width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: snapshot.data!.data!.features!.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  radius: 05,
                                  backgroundColor: Color(0xffC4C4C4)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                item,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
