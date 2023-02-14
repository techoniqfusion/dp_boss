import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class PointsTransferProvider extends ChangeNotifier{

  bool buttonLoader = false;
  final appAPi = AppApi();

  Future pointsTransfer(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.pointsTransferApi(body: body);
      print("Points Transfer api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
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
      print("Points Transfer API error $error");
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