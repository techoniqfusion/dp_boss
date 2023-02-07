import 'package:flutter/material.dart';

class AppSize {
  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static getAppBarHeight(BuildContext context) {
    return (AppBar().preferredSize.height +
        (MediaQuery.of(context).padding.top));
  }
}