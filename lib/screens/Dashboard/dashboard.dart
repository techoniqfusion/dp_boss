import 'package:dp_boss/screens/Dashboard/Account%20Screen/account_view.dart';
import 'package:dp_boss/screens/Dashboard/History%20Screen/history_view.dart';
import 'package:dp_boss/screens/Dashboard/Profile%20Screen/profile_view.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../model/bottom_navigation_model.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_route.dart';
import 'Home Screen/home_view.dart';

class Dashboard extends StatefulWidget {
  String? screenKey;
   Dashboard({Key? key, required this.screenKey}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<BottomBar> list = [
    BottomBar(
      child: const HomeView(),
      title: "Home",
      bottomIcon: AppImages.homeIcon,
      isSelect: true
    ),
    BottomBar(
        child: const ProfileView(),
        title: "Profile",
        bottomIcon: AppImages.profileIcon,
    ),
    BottomBar(
      child: const AccountView(),
      title: "Account",
      bottomIcon: AppImages.accountIcon,
    ),

    BottomBar(
      child: const HistoryView(),
      title: "History",
      bottomIcon: AppImages.historyIcon,
    ),
  ];


  @override
  Widget build(BuildContext context) {

    for (var element in list) {
      if(element.title == widget.screenKey){
        element.isSelect = true;
      }else{
        element.isSelect = false;
      }
    }

    var selectedPage = list.firstWhere((element) => element.isSelect);

    return Scaffold(
      appBar: AppBar(
        actions: [
          iconCard(
              icon: SvgPicture.asset(
                AppImages.accountIcon,
                color: AppColor.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppScreen.walletScreen);
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Stack(
              children: <Widget>[
                iconCard(
                    icon: SvgPicture.asset(AppImages.notificationIcon),
                    onPressed: () {
                      Navigator.pushNamed(context, AppScreen.notificationScreen);
                    }),
                Visibility(
                  child: Positioned(
                    right: 3,
                    bottom: 26,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: AppColor.lightPurple,
                          shape: BoxShape.circle),
                      child: const Text(
                        "2",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        title: const Text.rich(TextSpan(
            text: "DP ",
            style: TextStyle(
                color: AppColor.black,
                fontSize: 16,
                fontFamily: AppFont.poppinsSemiBold),
            children: [
              TextSpan(
                text: "Boss",
                style: TextStyle(
                    color: AppColor.black,
                    fontSize: 16,
                    fontFamily: AppFont.poppinsRegular),
              )
            ])),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: AppSize.getWidth(context),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColor.lightYellow.withOpacity(1),
            borderRadius: BorderRadius.circular(23),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var item in list)
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                //enableFeedback: false,
                  onTap: () {
                    // for (var element in list) {
                    //   element.isSelect = false;
                    // }
                    // item.isSelect = true;
                    widget.screenKey = item.title;
                    setState(() {});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(item.bottomIcon, color: item.isSelect ? AppColor.yellow : AppColor.iconGrey),
                      const SizedBox(height: 5),
                      Text(item.title,style: TextStyle(
                        fontSize: 12,
                        color: item.isSelect ? AppColor.black : AppColor.iconGrey
                      ),)
                    ],
                  )),
          ],
        ),
      ),
      body: selectedPage.child,
    );
  }
}
