import 'package:flutter/cupertino.dart';

import '../utils/app_color.dart';

Widget dot({double rightMargin = 0.0}){
  return Container(
    margin: EdgeInsets.only(left: 5,right: rightMargin),
    width: 6,
    height: 6,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.lightYellow
    ),
  );
}