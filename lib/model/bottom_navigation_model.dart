import 'package:flutter/cupertino.dart';

class BottomBar{
  Widget child;
  String title;
  bool isSelect;
  String bottomIcon;
  BottomBar({required this.child, required this.title, this.isSelect = false, required this.bottomIcon});
}


