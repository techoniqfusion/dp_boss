import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/app_route.dart';

class RecoverPasswordProvider extends ChangeNotifier {
  bool buttonLoader = false;
  final appAPi = AppApi();

  Future recoverPassword(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.sendOtpApi(body: body);
      print("Recover Password api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
      } else {
        if (response.data['status_code'] == 201) {
          updateLoader(false);
          popUp(
            context: context,
            title: "${response.data['phone']['message']}", // show popUp
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
        // else {
        //   updateLoader(false);
        //   cancelTimer();
        //   popUp(
        //     context: context,
        //     title: "${response.data['message']}", // show popUp
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: const Text("okay"),
        //       ),
        //     ],
        //   );
        // }
      }
      return response.data;
    } catch (error) {
      print("Recover Password API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  Future recoverPasswordVerification(
      BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.recoverPasswordVerify(body: body);
      print("Recover Password Verification api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
      } else {
        if (response.data['status_code'] == 201) {
          updateLoader(false);
          popUp(
            context: context,
            title: "${response.data['phone']['message']}", // show popUp
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
        // else {
        //   updateLoader(false);
        //   cancelTimer();
        //   popUp(
        //     context: context,
        //     title: "${response.data['message']}", // show popUp
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: const Text("okay"),
        //       ),
        //     ],
        //   );
        // }
      }
      return response.data;
    } catch (error) {
      print("Recover Password Verification API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  Future recoverPasswordStore(BuildContext context, FormData body) async {
    try {
      updateLoader(true);
      final response = await appAPi.recoverPasswordStore(body: body);
      print("Recover Password Store api response ${response.data}");
      if (response.data['status_code'] == 200) {
        updateLoader(false);
        popUp(
            context: context, title: "${response.data['message']}",
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppScreen.login, (route) => false);
                  },
                  child: const Text("okay"))
            ]
        );
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
        // else {
        //   updateLoader(false);
        //   cancelTimer();
        //   popUp(
        //     context: context,
        //     title: "${response.data['message']}", // show popUp
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: const Text("okay"),
        //       ),
        //     ],
        //   );
        // }
      }
      return response.data;
    } catch (error) {
      print("Recover Password Store API error $error");
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
