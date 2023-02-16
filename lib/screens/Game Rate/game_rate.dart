import 'package:dp_boss/API%20Response%20Model/Game%20Rate%20Model/game_rate_model.dart';
import 'package:dp_boss/Component/custom_loader.dart';
import 'package:dp_boss/Providers/Game%20Rate%20Provider/game_rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Component/icon_card.dart';
import '../../Component/try_again.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class GameRate extends StatefulWidget {
  const GameRate({Key? key}) : super(key: key);

  @override
  State<GameRate> createState() => _GameRateState();
}

class _GameRateState extends State<GameRate> {
  Future getRefreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameRateProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Game Rate",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: FutureBuilder(
          future: provider.gameRate(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final gameRateList = snapshot.data as List<GameRateModel>;
                final gameList = gameRateList[0];
                // print("History data is ${historyData.first.subject}");
                return RefreshIndicator(
                    color: AppColor.lightYellow,
                    onRefresh: getRefreshData,
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      children: [
                        gameCard(
                            gameName: "Single Digit",
                            gameRating1: gameList.singleDigitValue1,
                            gameRating2: gameList.singleDigitValue2),
                        gameCard(
                            gameName: "Jodi Digit",
                            gameRating1: gameList.jodiDigitValue1,
                            gameRating2: gameList.jodiDigitValue2),
                        gameCard(
                            gameName: "Single Pana",
                            gameRating1: gameList.singlePanaValue1,
                            gameRating2: gameList.singleDigitValue2),
                        gameCard(
                            gameName: "Double Pana",
                            gameRating1: gameList.doublePanaValue1,
                            gameRating2: gameList.doublePanaValue2),
                        gameCard(
                            gameName: "Triple Pana",
                            gameRating1: gameList.tripplePanaValue1,
                            gameRating2: gameList.tripplePanaValue2),
                        gameCard(
                            gameName: "Half Sangam",
                            gameRating1: gameList.halfSangamValue1,
                            gameRating2: gameList.halfSangamValue2),
                        gameCard(
                            gameName: "Full Sangam",
                            gameRating1: gameList.fullSangamValue1,
                            gameRating2: gameList.fullSangamValue2),
                      ],
                    ));
              } else {
                return tryAgain(onTap: () => setState(() {}));
              }
            }
            return customLoader();
          }),
    );
  }

  Widget gameCard(
      {required String gameName,
      required String? gameRating1,
      required String? gameRating2}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      margin: EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: AppColor.customWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(gameName,
              style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                  fontFamily: AppFont.poppinsSemiBold,
                  overflow: TextOverflow.ellipsis)),
          Text(
            "${gameRating1} - ${gameRating2}",
            style: TextStyle(
                color: AppColor.black,
                fontSize: 16,
                fontFamily: AppFont.poppinsSemiBold,
                overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );
  }
}
