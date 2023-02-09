import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class VerificationProvider extends ChangeNotifier {

  bool buttonLoader = false;
  final appAPi = AppApi();

  Future verification(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.verificationApi(body: body);
      print("api response data");
      print(response.data);
      if (response.data['status'] == true) {
        updateLoader(false);
      } else {
        if (response.data['status_code'] == 401) {
          updateLoader(false);
          popUp(
            context: context,
            title: "Session is expired",
            actions: [
              TextButton(
                onPressed: () {
                  LogOutUser.logout(context);
                },
                child: const Text("okay"),
              ),
            ],
          );
        } else {
          updateLoader(false);
          popUp(
            context: context, title: response.data['mess'], // show popUp
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
      return response;
    } catch (error) {
      updateLoader(false);
      print("Verification API error $error");
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    buttonLoader = status;
    notifyListeners();
  }
}
