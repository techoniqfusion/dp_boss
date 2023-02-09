import 'package:flutter/cupertino.dart';

class AppColor{
  static const black = Color(0xff0A0A0A);
  static const yellow = Color(0xffF4C000);
  static const white = Color(0xffF5F5F5);
  static const shadowGrey = Color(0xffC4C4C4);
  static const customGrey = Color(0xffB4B9C1);
  static const grey1 = Color(0xff6c757d);
  static const iconGrey = Color(0xff85847E);
  static const lightYellow = Color(0xffFEE27A);
  static const lightPurple = Color(0xff7893F6);
  static const yellow1 = Color(0xffE5B606);
  static const lightYellow1 = Color(0xffFFE584);
  static const neon = Color(0xff50E37A);
  static const cherry = Color(0xffFB6B6B);
  static const lightYellow2 = Color(0xffFEEBA6);
  static const darkGrey = Color(0xff434343);
  static const customWhite = Color(0xffF5F5F5);
  static const green = Color(0xff28a745);

  static const Gradient yellowGradient = LinearGradient(
    colors: [lightYellow, yellow1],
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    // stops: [0.1, 9.0],
  );

  static const Gradient yellowGradient2 = LinearGradient(
    colors: [lightYellow, yellow1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 10.0],
  );

  static const Gradient yellowGradient1 = LinearGradient(
    colors: [yellow1,lightYellow1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.5, 9.0],
  );
}