import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_route.dart';
import 'db_helper.dart';

class LogOutUser{

  static Future logout(BuildContext context) async {
    final sqliteDb = SQLService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await sqliteDb.openDB();
    await prefs.clear();
    await sqliteDb.deleteUser();
    print("user logout");
    Navigator.pushNamedAndRemoveUntil(
        context, AppScreen.login, (route) => false);
  }
}