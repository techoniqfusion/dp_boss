import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_images.dart';
import 'custom_button.dart';

Widget tryAgain({required Function () onTap}){
  return Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
          child: Image.asset(AppImages.errorImg,height: 250)
      ),
      SizedBox(height: 10,),
      CustomButton(
          height: 20,
          radius: 30,
          side: MaterialStateProperty.all<BorderSide>(
              BorderSide(width: 1, color: Colors.red)),
          backgroundColor: MaterialStateProperty.all<Color>(
              AppColor.lightYellow),
          buttonText: "Try Again",
          fontSize: 14,
          textColor: Colors.black,
          onPressed: onTap
      ),
    ],
  );
}