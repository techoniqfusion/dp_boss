import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Support History All Data/support_history_all_data_model.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class SupportHistoryProvider extends ChangeNotifier{

  final appAPi = AppApi();
  List<SupportHistoryModel> supportHistoryList = [];

  Future supportHistory(BuildContext context) async{
    try{
      final response = await appAPi.supportHistoryAllData();
      if(response.data['status'] == true){
        List temp = response.data['Support'];
        supportHistoryList = temp.map((e) => SupportHistoryModel.fromJson(e)).toList();
        return supportHistoryList;
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
      print("Support History API error $error");
      rethrow;
    }
  }
}