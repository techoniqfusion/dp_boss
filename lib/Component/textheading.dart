import 'package:flutter/cupertino.dart';
import '../utils/app_color.dart';
import '../utils/app_font.dart';

Widget textHeading({required String text}) {
  var fontStyle = const TextStyle(
      color: AppColor.black,
      fontFamily: AppFont.poppinsSemiBold,
      fontSize: 14);
  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Text(
      text,
      style: fontStyle,
    ),
  );
}