import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customLoader({Color? color = Colors.black}){
  return Center(
    child: CupertinoActivityIndicator(
      color: color,
    ),
  );
}