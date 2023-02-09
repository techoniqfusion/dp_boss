import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import 'package:dio/dio.dart';
import '../../Component/pop_up.dart';
import '../../utils/app_route.dart';
import '../../utils/logout_user.dart';

class SupportCreateRequestProvider extends ChangeNotifier{
  final appAPi = AppApi();
  bool isShowLoader = false;

  Future supportCreateRequest(BuildContext context, FormData data) async{
    try{
      updateLoader(true);
      final response = await appAPi.supportCreateRequest(body: data);
      print("api response data");
      print(response.data);
      if(response.data['status'] == true){
        updateLoader(false);
        popUp(context: context, title: response.data['message'], actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("okay"),
          ),
        ]);
      }
      else {
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
    }
    catch (error) {
      updateLoader(false);
      print("Support Create Request API error $error");
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    isShowLoader = status;
    notifyListeners();
  }
}