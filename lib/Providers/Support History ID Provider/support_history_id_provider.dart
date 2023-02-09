import 'package:dio/dio.dart';
import 'package:dp_boss/API%20Response%20Model/Support%20History%20ID%20Model/support_history_id_model.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class SupportHistoryIdProvider extends ChangeNotifier{
  final appAPi = AppApi();
  List<SupportHistoryIdModel> supportHistoryIDList = [];

  Future supportDataId(BuildContext context, String supportId) async{
    try{
      final response = await appAPi.supportData(supportId);
      if(response.data['status'] == true){
        List temp = response.data['SupportHistory'];
        supportHistoryIDList = temp.map((e) => SupportHistoryIdModel.fromJson(e)).toList();
        notifyListeners();
        return supportHistoryIDList;
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
      print("Support History ID API error $error");
      rethrow;
    }
  }
}