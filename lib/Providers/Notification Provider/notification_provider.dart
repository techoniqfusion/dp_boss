import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Notification Model/notification_model.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class NotificationProvider extends ChangeNotifier{

  final appAPi = AppApi();
  List<NotificationModel> notificationList = [];

  Future<List<NotificationModel>?> notificationCall(BuildContext context) async{
    try {
      final response = await appAPi.notificationApi();
      if (response.data['status'] == true) {
        List temp = response.data['data'];
        notificationList =
            temp.map((e) => NotificationModel.fromJson(e)).toList();
        return notificationList;
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
      print("Notification API error $error");
      rethrow;
    }
    return null;
  }
}