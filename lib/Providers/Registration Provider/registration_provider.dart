import 'package:dio/dio.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';

class RegistrationProvider extends ChangeNotifier{

  bool buttonLoader = false;
  final appAPi = AppApi();

  Future registration(BuildContext context, FormData body, String mobileNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      updateLoader(true);
      final response = await appAPi.registrationAPI(body: body);
      print("registration api response ${response.data}");
      if(response.data['status_code'] == 200){
        await prefs.setBool("isRegistered", true);
        await prefs.setString("mobileNumber", mobileNumber);
        updateLoader(false);
        Navigator.pushNamed(context, AppScreen.otpScreen,arguments: {
          'mobile': mobileNumber,
          'isAppClosed': true,
          'isRecoverPassword' : false
        });
      }
      else{
        if(response.data['status_code'] == 204){
          updateLoader(false);
          popUp(context: context, title: "${response.data['message']}", // show popUp
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
        // else{
        //   updateLoader(false);
        //   popUp(context: context, title: "${response.data['message']}", // show popUp
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
    } catch(error){
      print("Registration API error $error");
      updateLoader(false);
      rethrow;
    }
  }

  Future verifyOtp(BuildContext context, FormData body) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      updateLoader(true);
      final response = await appAPi.verifyOtpApi(body: body);
      print("OTP verify api response ${response.data}");
      if(response.data['status_code'] == 200){
       await prefs.setBool("isLoggedIn", true);
       await prefs.setBool("isRegistered", false);
       updateLoader(false);
        Navigator.pushNamedAndRemoveUntil(
            context, AppScreen.login, (route) => false);
      }
      else{
        if(response.data['status_code'] == 201){
          updateLoader(false);
          popUp(context: context, title: "${response.data['message']}", // show popUp
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
        // else{
        //   updateLoader(false);
        //   popUp(context: context, title: "${response.data['message']}", // show popUp
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
    }
    catch(error){
      print("OTP verify API error $error");
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