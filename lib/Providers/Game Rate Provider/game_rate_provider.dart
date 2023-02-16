import 'package:dp_boss/API%20Response%20Model/Game%20Rate%20Model/game_rate_model.dart';
import 'package:flutter/material.dart';
import '../../API Integration/call_api.dart';
import '../../Component/pop_up.dart';
import '../../utils/logout_user.dart';

class GameRateProvider extends ChangeNotifier{

  final appAPi = AppApi();
  List<GameRateModel> gameRateList = [];

  Future gameRate(BuildContext context) async{
    try{
      final response = await appAPi.pointRate();
      if(response.data['status'] == true){
        List temp = response.data['data'];
        gameRateList = temp.map((e) => GameRateModel.fromJson(e)).toList();
        return gameRateList;
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
      print("Game Rate API error $error");
      rethrow;
    }
  }
}