import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/styles/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBars(
          withIcon: false,
          context: context,
          text: "about_us".tr,
          canBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              CustomText(
                text: 'chairman_message'.tr,
                alignment: Alignment.center,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              DescriptionTextWidget(text: 'chairman_message1'.tr),
              CustomText(
                text: 'who_we_are'.tr,
                alignment: Alignment.center,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              DescriptionTextWidget(
                  text: '${'who_we_are1'.tr}\n\n${'who_we_are2'.tr}\n${'who_we_are3'.tr}\n${'who_we_are4'.tr}\n${'who_we_are5'.tr}'),
              CustomText(
                text: 'mission'.tr,
                alignment: Alignment.center,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              DescriptionTextWidget(text: 'mission1'.tr),
              CustomText(
                text: 'accreditation'.tr,
                alignment: Alignment.center,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              DescriptionTextWidget(text: 'accreditation1'.tr),
              CustomText(
                text: 'services'.tr,
                alignment: Alignment.center,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              DescriptionTextWidget(
                  text: '${'services1'.tr}\n${'services2'.tr}\n${'services3'.tr}\n${'services4'.tr}\n${'services5'.tr}\n${'services6'.tr}\n${'services7'.tr}\n${'services8'.tr}\n${'services9'.tr}\n${'services10'.tr}\n${'services11'.tr}\n${'services12'.tr}\n${'services13'.tr}\n${'services14'.tr}\n${'services15'.tr}\n${'services16'.tr}\n${'services17'.tr}\n${'services18'.tr}\n${'services19'.tr}\n${'services20'.tr}\n${'services21'.tr}\n${'services22'.tr}\n${'services23'.tr}\n${'services24'.tr}\n${'services25'.tr}\n${'services26'.tr}\n${'services27'.tr}\n\n${'transportation'.tr}\n\n${'services28'.tr}\n\n${'services29'.tr}\n\n${'services30'.tr}\n\n${'services31'.tr}\n\n${'services32'.tr}\n\n${'services33'.tr}\n\n${'services34'.tr}\n${'services35'.tr}\n${'services36'.tr}\n${'services37'.tr}\n${'services38'.tr}\n${'services39'.tr}\n${'services40'.tr}\n${'services41'.tr}\n${'services42'.tr}\n${'services43'.tr}\n${'services44'.tr}\n${'services45'.tr}\n\n${'services46'.tr}\n\n${'services47'.tr}\n${'services48'.tr}\n${'services49'.tr}\n${'services50'.tr}\n\n${'services51'.tr}\n\n${'services52'.tr}\n\n${'services53'.tr}\n\n${'services54'.tr}'),
            ],
          ),
        ));
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              children: <Widget>[
                Text(
                  flag ? ("$firstHalf...") : (firstHalf + secondHalf),
                  style: const TextStyle(fontSize: 18),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? "show_more".tr : "show_less".tr,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
