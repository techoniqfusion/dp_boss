import 'package:dp_boss/API%20Response%20Model/Bank%20Details%20List%20Model/bank_details_list_model.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class BankDetailsListProvider extends ChangeNotifier{

  final appAPi = AppApi();

  Future bankDetails(BuildContext context) async{
    try{
      final response = await appAPi.bankAllData();
      if(response.data['status'] == true){
        final responseData = BankDetailsListModel.fromJson(response.data);
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
      print("Bank Details List API error $error");
      rethrow;
    }
  }
}