import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';

class SupremeDay extends StatefulWidget {
  final String gameName;
  final String points;
  const SupremeDay({Key? key, required this.gameName, required this.points})
      : super(key: key);

  @override
  State<SupremeDay> createState() => _SupremeDayState();
}

class _SupremeDayState extends State<SupremeDay> {
  @override
  Widget build(BuildContext context) {
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
          widget.gameName,
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            runSpacing: 15,
            alignment: WrapAlignment.center,
            spacing: 55,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.gameDetails,
                        arguments: {
                          "gameType": "Single Digit",
                          "points": widget.points
                        });
                  },
                  child: Image.asset(
                    AppImages.singleDigit,
                    height: 126.62,
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.gameDetails,
                        arguments: {
                          "gameType": "Jodi Digit",
                          "points": widget.points
                        });
                  },
                  child: Image.asset(
                    AppImages.jodiDigit,
                    height: 126.62,
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.gameDetails,
                        arguments: {
                          "gameType": "Single Panna",
                          "points": widget.points
                        });
                  },
                  child: Image.asset(
                    AppImages.singlePanna,
                    height: 126.62,
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.gameDetails,
                        arguments: {
                          "gameType": "Double Panna",
                          "points": widget.points
                        });
                  },
                  child: Image.asset(
                    AppImages.doublePanna,
                    height: 126.62,
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.gameDetails,
                        arguments: {
                          "gameType": "Tripple Panna",
                          "points": widget.points
                        });
                  },
                  child: Image.asset(
                    AppImages.tripplePanna,
                    height: 126.62,
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppScreen.gameDetails,
                      arguments: {
                        "gameType": "Half Sangam",
                        "points": widget.points
                      });
                },
                child: Image.asset(
                  AppImages.halfSangam,
                  height: 126.62,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppScreen.gameDetails,
                      arguments: {
                        "gameType": "Full Sangam",
                        "points": widget.points
                      });
                },
                child: Image.asset(
                  AppImages.fullSangam,
                  height: 126.62,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
