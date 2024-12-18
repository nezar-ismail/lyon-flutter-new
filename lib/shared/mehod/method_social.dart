import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void contactEmail({required String email}) async {
  var url = 'mailto:info@lyon-jo.com';
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openUrl({required String url}) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
Future<void> launchPhoneDialer(String contactNumber) async {
  final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
  try {
    // ignore: deprecated_member_use
    if (await canLaunch(_phoneUri.toString())) {
      // ignore: deprecated_member_use
      await launch(_phoneUri.toString());
    }
  } catch (error) {
    throw ("Cannot dial");
  }
}

// ignore: non_constant_identifier_names
OpenWhatsapp({required BuildContext context,required String number}) async {
  // ignore: non_constant_identifier_names
  var WhatsappURlAndroid =
      "whatsapp://send?phone=" + number ;
  // ignore: non_constant_identifier_names
  var whatappURL_ios = "https://api.whatsapp.com/send?phone=$number=${Uri.parse('Hello')}";
  if (Platform.isIOS) {

    // ignore: deprecated_member_use
    if (await canLaunch(whatappURL_ios)) {
      // ignore: deprecated_member_use
      await launch(whatappURL_ios, forceSafariVC: false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
    }
  } else {
    // android , web
    // ignore: deprecated_member_use
    if (await canLaunch(WhatsappURlAndroid)) {
      // ignore: deprecated_member_use
      await launch(WhatsappURlAndroid);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
    }
  }
}
