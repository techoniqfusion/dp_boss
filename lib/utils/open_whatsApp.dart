import 'dart:io';
import 'package:dp_boss/Component/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSocialMediaApp {
  static openWhatsApp(
      {required String mobileNumber, required BuildContext context}) async {
    var whatsapp = mobileNumber;
    // "+919144040888";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
        await launchUrl(Uri.parse(whatsappURL_ios));
      } else {
        CustomSnackBar.mySnackBar(context, "whatsapp not installed");
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: new Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
        await launchUrl(Uri.parse(whatsappURl_android));
      } else {
        CustomSnackBar.mySnackBar(context, "whatsapp not installed");
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: new Text("whatsapp not installed")));
      }
    }
  }
}
