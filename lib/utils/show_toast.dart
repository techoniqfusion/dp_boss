import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_color.dart';

void showToast(String msg) => Fluttertoast.showToast(
  msg: msg,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: AppColor.neon,
  textColor: AppColor.white,
  fontSize: 16.0,);