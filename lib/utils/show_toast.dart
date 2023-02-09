import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_color.dart';

void showToast(String msg) => Fluttertoast.showToast(
  msg: msg,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: AppColor.lightYellow,
  textColor: AppColor.black,
  fontSize: 16.0,);