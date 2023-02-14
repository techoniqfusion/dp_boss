import 'package:dp_boss/API%20Response%20Model/Transaction%20History%20Model/transaction_history_model.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class TransactionHistoryProvider extends ChangeNotifier{

  final appAPi = AppApi();

  Future transactionHistory(BuildContext context) async{
    try{
      final response = await appAPi.transactionHistoryApi();
      if(response.data['status'] == true){
        print("transaction history response is ${response.data}");
        final responseData = TransactionHistoryModel.fromJson(response.data);
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
      print("Transaction History API error $error");
      rethrow;
    }
  }
}