import 'package:flutter/material.dart';
import '../utils/app_color.dart';

Widget iconCard({required Widget icon, void Function()? onPressed,
double height = 30, double width = 30,
double radius = 10
}){
  return Center(
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: AppColor.yellowGradient
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: icon),
    ),
  );
}