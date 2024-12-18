import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/styles/colors.dart';

import '../shared/mehod/method_social.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Image.asset(
            "assets/images/location2.jpg",
            fit: BoxFit.cover,
            width: width,
            height: height / 5,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () =>
                openUrl(url: "https://maps.app.goo.gl/KpvQeBBAS14ZByAC9"),
            child: Column(
              children: [
                Text(
                  "airport".tr,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.access_time),
                        Text('airport office'.tr),
                        Text('everyday'.tr),
                        Text('24 hours'.tr),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                        ),
                        CustomText(
                          text: "open map".tr,
                          color: secondaryColor1,
                          alignment: Alignment.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () =>
                openUrl(url: "https://maps.app.goo.gl/xTmgK3j4m9Q8s5rW8"),
            child: Column(
              children: [
                Text(
                  "bayader".tr,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.access_time),
                        Text('amman office'.tr),
                        Text('sunday - thursday'.tr),
                        Text('9am - 6pm'.tr),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                        ),
                        CustomText(
                          text: "open map".tr,
                          color: secondaryColor1,
                          alignment: Alignment.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => launchPhoneDialer('00962777477748'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_iphone_rounded),
                Column(
                  children: [
                    CustomText(
                      text: '+962777477748',
                      alignment: Alignment.center,
                      size: 20,
                      color: secondaryColor1,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: width * .2,
                height: height * .1,
              ),
              const SizedBox(
                width: 40,
              ),
              Image.asset('assets/images/marvell.png',
                  width: width * .2, height: height * .1),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => openUrl(
                url:
                    "https://www.google.com/maps/place//data=!4m3!3m2!1s0x151ca133ed47a089:0xa4f9b5c5fe45c80e!12e1?source=g.page.m.ia._&laa=nmx-review-solicitation-ia2"),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Review us on Google Maps",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor1)),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
