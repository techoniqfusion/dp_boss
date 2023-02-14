import 'package:dp_boss/API%20Response%20Model/Dashboard%20Model/dashboard_model.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Providers/Dashboard%20Provider/dashboard_provider.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_loader.dart';
import '../../../Component/try_again.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    return Scaffold(
        body: FutureBuilder(
      future: provider.dashboardApi(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) if (snapshot
            .hasData) {
          final dashboardData = snapshot.data as DashboardModel;
          var gameList = dashboardData.gameData;
          var newDate = DateFormat('yyyy/MM/dd')
              .parse(dashboardData.date?.replaceAll('-', '/') ?? "");
          var day = (DateFormat('EEEE').format(newDate)).toLowerCase();
          print("day $day");
          // var descendingOrder = bankDetailList.reversed.toList();
          // print("History data is ${historyData.first.subject}");
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: 173,
                  width: AppSize.getWidth(context),
                  decoration: BoxDecoration(
                      gradient: AppColor.yellowGradient1,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Balance",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: AppFont.poppinsMedium),
                      ),
                      Text.rich(TextSpan(
                          text: "₹",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 34,
                              color: Colors.white,
                              fontFamily: AppFont.poppinsSemiBold),
                          children: [
                            TextSpan(
                              text: dashboardData.wallet,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontFamily: AppFont.poppinsBold),
                            )
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppImages.depositIcon),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Deposit",
                            style: TextStyle(
                                fontFamily: AppFont.poppinsSemiBold,
                                fontSize: 14,
                                color: AppColor.black),
                          ),
                          Spacer(),
                          SvgPicture.asset(AppImages.withdrawalIcon),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Withdrawal",
                            style: TextStyle(
                                fontFamily: AppFont.poppinsSemiBold,
                                fontSize: 14,
                                color: AppColor.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: Image.asset(AppImages.gameCard)),
                    Positioned(
                      left: 25,
                      bottom: 18,
                      child: CustomButton(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.yellow1.withOpacity(0.4)),
                        radius: 29,
                        height: 40,
                        width: 70,
                        buttonText: "Play & Win",
                        textColor: AppColor.white,
                        fontSize: 12.9,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: dashboardData.gameData?.isNotEmpty ?? false,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: 10, bottom: kBottomNavigationBarHeight + 30),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: gameList?.length,
                    itemBuilder: (context, index) {
                      var sdd = gameList?[index].toJson();
                      var opentime = (DateTime.parse(dashboardData.date! +
                              ' ' +
                              sdd?[day + '_open_time']))
                          .millisecondsSinceEpoch;
                      var closetime = (DateTime.parse(dashboardData.date! +
                              ' ' +
                              sdd?[day + '_close_time']))
                          .millisecondsSinceEpoch;
                      var current_time = (DateTime.parse(
                              dashboardData.date! + ' ' + dashboardData.time!))
                          .millisecondsSinceEpoch;
                      print(opentime <= current_time &&
                          closetime >= current_time);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          tileColor: AppColor.white,
                          leading: Container(
                            height: 51,
                            width: 51,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: AppColor.yellowGradient),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    gameList?[index].name ?? "",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsSemiBold),
                                  ),
                                  Text(
                                    opentime <= current_time &&
                                            closetime >= current_time
                                        ? "Running"
                                        : "Closed",
                                    style: TextStyle(
                                        color: opentime <= current_time &&
                                                closetime >= current_time
                                            ? AppColor.neon
                                            : Colors.red,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsMedium),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${DateFormat.jm().format(DateFormat("hh:mm:ss").parse("${sdd?[day + '_open_time']}"))} - ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse("${sdd?[day + '_close_time']}"))}",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsMedium),
                                  ),
                                  Text(
                                    gameList?[index].winningNumber ?? "",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsMedium),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return tryAgain(onTap: () => setState(() {}));
        }
        return customLoader();
      },
    ));
  }
}
