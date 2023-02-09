import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class AddBankDetailsProvider extends ChangeNotifier {
  bool isShowLoader = false;
  final appAPi = AppApi();

  Future addBankDetails(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.addBankDetailApi(body: body);
      if (response.data['status'] == 200) {
        popUp(
            context: context, title: response.data['message'],
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("okay"),
            ),
          ],
        );
        updateLoader(false);
      } else {
        updateLoader(true);
        if (response.data['status'] == 401) {
          popUp(
            context: context,
            title: "Session is expired",
            actions: [
              TextButton(
                onPressed: () {
                  LogOutUser.logout(context);
                },
                child: const Text("okay"),
              ),
            ],
          );
        } else {
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
      }
      return response.data;
    } catch (error) {
      print("Add Bank Details API error $error");
      rethrow;
    }
  }

  /// Show/Hide loader functionality
  updateLoader(bool status) {
    isShowLoader = status;
    notifyListeners();
  }
}
