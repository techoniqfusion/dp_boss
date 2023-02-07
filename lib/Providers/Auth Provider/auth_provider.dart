import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dp_boss/Component/pop_up.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API Integration/API URL endpoints/api_endpoints.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Registration Model/registration_model.dart';
import '../../utils/db_helper.dart';

class AuthProvider extends ChangeNotifier {
  Timer? timer;
  int start = 60;
  bool buttonLoader = false;
  final appAPi = AppApi();

  void startTimer() {
    start = 60;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        timer.cancel();
        notifyListeners();
      } else {
        start--;
        notifyListeners();
      }
    });
  }

  cancelTimer() {
    timer?.cancel();
    print("timer cancel value ${timer?.tick}");
    notifyListeners();
  }

  restartTimer() {
    start = 60;
    notifyListeners();
  }

  Future login(BuildContext context, FormData body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sqliteDb = SQLService();
    await sqliteDb.openDB();
    try{
      updateLoader(true);
      final response = await appAPi.loginAPI(body: body);
      // await Dio().post("${Endpoints.baseUrl}login/login-user", data: body);
      if (response.data['status_code'] == 200){
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("userToken", response.data['token']);
        final users = UserData.fromJson(response.data['data']);
        await sqliteDb.addToUser(users);
        updateLoader(false);
        Navigator.popAndPushNamed(context, AppScreen.dashboard);
      }
      else{
        updateLoader(false);
        if(response.data['status_code'] == 201){
          popUp(
            context: context,
            title: "${response.data['message']}", // show popUp
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("okay"),
              ),
            ],
          );
        }
      }
    }
    catch (error) {
      print("login API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  Future sendOtp(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.sendOtpApi(body: body);
      print("Send OTP api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
        popUp(
          context: context,
          title: "${response.data['message']}",
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("okay"),
            ),
          ],
        );
      } else {
        if (response.data['status_code'] == 201) {
          updateLoader(false);
          popUp(
            context: context,
            title: "${response.data['message']}", // show popUp
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("okay"),
              ),
            ],
          );
        }
        // else {
        //   updateLoader(false);
        //   cancelTimer();
        //   popUp(
        //     context: context,
        //     title: "${response.data['message']}", // show popUp
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: const Text("okay"),
        //       ),
        //     ],
        //   );
        // }
      }
      return response.data;
    } catch (error) {
      print("Send OTP API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  updateLoader(bool status) {
    buttonLoader = status;
    notifyListeners();
  }
}
