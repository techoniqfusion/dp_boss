import 'package:dp_boss/API%20Response%20Model/Dashboard%20Model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class DashboardProvider extends ChangeNotifier{

  final appAPi = AppApi();

  Future dashboardApi(BuildContext context) async{
    try{
      final response = await appAPi.dashboardApi();
      if(response.data['status'] == true){
        print("dashboard api response is ${response.data}");
        final responseData = DashboardModel.fromJson(response.data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("upiId", responseData.upi ?? "");
        // notifyListeners();
        return responseData;
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
    }
    catch (error) {
      print("Dashboard API error $error");
      rethrow;
    }
  }
}