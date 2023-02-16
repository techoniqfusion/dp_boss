import 'package:dp_boss/API%20Response%20Model/Withdrawal%20All%20Data%20Model/withdrawal_all_data_model.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class WithdrawalAllDataProvider extends ChangeNotifier{
  final appAPi = AppApi();
  List<WithdrawalAllDataModel> withdrawalDataList = [];

  Future withdrawalAllData(BuildContext context) async{
    try{
      final response = await appAPi.withdrawalAllDataApi();
      if(response.data['status'] == true){
        List temp = response.data['data'];
        withdrawalDataList = temp.map((e) => WithdrawalAllDataModel.fromJson(e)).toList();
        // notifyListeners();
        return withdrawalDataList;
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
      print("Withdrawal All Data API error $error");
      rethrow;
    }
  }
}