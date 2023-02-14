import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class AddUpiProvider extends ChangeNotifier{

  bool buttonLoader = false;
  final appAPi = AppApi();

  Future addUpi(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.withdrawalUpi(body: body);
      print("Add UPI api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
      } else {
        if (response.data['status_code'] == 201) {
          updateLoader(false);
        }
        if(response.data['status_code'] == 401){
          popUp(context: context, title: "Session is expired",
            actions: [
              TextButton(
                onPressed: () {
                  LogOutUser.logout(context);
                },
                child: const Text("okay"),
              ),
            ],
          );
        }
      }
      return response.data;
    } catch (error) {
      print("Add UPI API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    buttonLoader = status;
    notifyListeners();
  }
}