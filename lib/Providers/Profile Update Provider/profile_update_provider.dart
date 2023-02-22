import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Registration Model/registration_model.dart';
import '../../Component/pop_up.dart';
import '../../utils/db_helper.dart';
import '../../utils/logout_user.dart';

class ProfileUpdateProvider extends ChangeNotifier {
  bool profileUpdateLoader = false;
  final appAPi = AppApi();

  Future updateProfile(BuildContext context, FormData data) async {
    final sqliteDb = SQLService();
    await sqliteDb.openDB();
    try {
      updateLoader(true);
      final response = await appAPi.profileUpdateApi(body: data);
      print("response status is $response");
      if (response.data['status'] == true) {
        final res = UserData.fromJson(response.data['data']);
        print("mobile number on response => ${res.mobile}");
        print("address data from response => ${response.data['data']}");
        await sqliteDb.updateUserData(res);
        updateLoader(false);
      }
      else {
        updateLoader(false);
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
        else{
          updateLoader(false);
          popUp(
            context: context, title: response.data['message'], // show popUp
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
      return response.data;
    } catch (error) {
      updateLoader(false);
      print("Update Profile API error $error");
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    profileUpdateLoader = status;
    notifyListeners();
  }
}