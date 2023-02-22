import 'dart:io';
import 'package:dp_boss/API%20Response%20Model/Dashboard%20Model/dashboard_model.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Providers/Dashboard%20Provider/dashboard_provider.dart';
import 'package:dp_boss/screens/Deposit%20Screen/deposit_screen.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:dp_boss/utils/open_whatsApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../API Integration/call_api.dart';
import '../../../API Response Model/Support Details Model/support_details_model.dart';
import '../../../Component/shimmer.dart';
import '../../../Component/try_again.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_route.dart';
import '../../../utils/show_toast.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final appApi = AppApi();
  var supportDetails;

  Future getRefreshData() async {
    setState(() {});
  }

  Future getSupportDetails() async {
    final response = await appApi.supportDetailsApi();
    if (response.data['status'] == true) {
      final responseData = SupportModel.fromJson(response.data['support_data']);
      // print("user whatsApp number ${responseData.whatsapp}");
      return responseData;
    }
  }

  @override
  void initState() {
    super.initState();
    getSupportDetails().then((value) {
      // setState(() {
      supportDetails = value;
      // });
    });
  }

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
              .parse(dashboardData.date!.replaceAll('-', '/'));
          var day = (DateFormat('EEEE').format(newDate)).toLowerCase();
          print("day $day");
          // var descendingOrder = bankDetailList.reversed.toList();
          // print("History data is ${historyData.first.subject}");
          return RefreshIndicator(
            color: AppColor.lightYellow,
            onRefresh: getRefreshData,
            child: Scrollbar(
              radius: Radius.circular(5),
              thickness: 5,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
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
                                text: "${dashboardData.wallet}",
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
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppScreen.depositScreen,
                                    arguments: {"upiId": dashboardData.upi});
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(AppImages.depositIcon),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Add Fund",
                                    style: TextStyle(
                                        fontFamily: AppFont.poppinsSemiBold,
                                        fontSize: 14,
                                        color: AppColor.black),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppScreen.withdrawalScreen);
                              },
                              child: Row(children: [
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
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: AppColor.yellowGradient1),
                    child: Row(
                      children: [
                        customCard(
                            icon: SvgPicture.asset(
                              AppImages.whatsApp_icon,
                              height: 25,
                            ),
                            iconName: "WhatsApp",
                            onTap: () {
                              OpenSocialMediaApp.openWhatsApp(
                                  mobileNumber: supportDetails.whatsapp ?? "",
                                  context: context);
                              // openWhatsApp();
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        customCard(
                            icon: Icon(Icons.call, size: 25),
                            iconName: "Call",
                            onTap: () async {
                              Uri phoneNumber =
                                  Uri.parse('tel:${supportDetails.callOne}');
                              await launchUrl(phoneNumber);
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        customCard(
                            icon: Icon(
                              Icons.add,
                              size: 25,
                              color: AppColor.black,
                            ),
                            iconName: "Add",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepositScreen(),
                                  ));
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColor.customWhite),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColor.lightYellow,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColor.lightYellow,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColor.lightYellow,
                            ),
                          ],
                        ),
                        Text(
                          "STARLINE",
                          style: TextStyle(
                              color: AppColor.black,
                              fontFamily: AppFont.poppinsSemiBold),
                        ),
                        Icon(
                          Icons.play_arrow,
                          color: AppColor.neon,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                          width: AppSize.getWidth(context),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Image.asset(
                            AppImages.gameCard,
                            fit: BoxFit.cover,
                          )),
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
                        var jsonData = gameList?[index].toJson();

                        var openTime = (DateTime.parse(dashboardData.date! +
                                ' ' +
                                jsonData?[day + '_open_time']))
                            .millisecondsSinceEpoch; // Convert open date time in string format to timestamp

                        var closeTime = (DateTime.parse(dashboardData.date! +
                                ' ' +
                                jsonData?[day + '_close_time']))
                            .millisecondsSinceEpoch; // Convert close date time in string format to timestamp

                        var current_time = (DateTime.parse(dashboardData.date! +
                                ' ' +
                                dashboardData.time!))
                            .millisecondsSinceEpoch; // Convert current date time in string format to timestamp

                        var formattedOpenTime = DateFormat.jm().format(
                            DateFormat("hh:mm:ss")
                                .parse("${jsonData?[day + '_open_time']}"));

                        var formattedCloseTime = DateFormat.jm().format(
                            DateFormat("hh:mm:ss")
                                .parse("${jsonData?[day + '_close_time']}"));
                        // print("open time $openTime");
                        // print("current time $current_time");
                        // print("close time $closeTime");
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.black, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColor.customWhite),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "OPEN ${formattedOpenTime}",
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontFamily:
                                                AppFont.poppinsSemiBold),
                                      ),
                                      Text(
                                        "CLOSE ${formattedCloseTime}",
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontFamily:
                                                AppFont.poppinsSemiBold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(context, AppScreen.gameChart);
                                          },
                                          child: Image.asset(
                                            AppImages.graphIcon,
                                            height: 30,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              gameList?[index].name ?? "",
                                              style: TextStyle(
                                                  color: AppColor.black,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily:
                                                      AppFont.poppinsSemiBold),
                                            ),
                                            Text(
                                              gameList?[index].winningNumber ??
                                                  "",
                                              style: TextStyle(
                                                  color: AppColor.black,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppFont.poppinsMedium),
                                            )
                                          ],
                                        ),
                                        openTime <= current_time &&
                                                    closeTime >= current_time ||
                                                day + "_status" == "active"
                                            ? GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "game name ${gameList?[index].name}");
                                                  Navigator.pushNamed(context,
                                                      AppScreen.supremeDay,
                                                      arguments: {
                                                        "points": dashboardData
                                                            .wallet,
                                                        "gameName":
                                                            gameList?[index]
                                                                .name
                                                      });
                                                },
                                                child: Image.asset(
                                                  AppImages.playButton,
                                                  height: 30,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  showToast(
                                                      "Currently market is closed now, when the market will open, then you invest your money in this market, please wait.");
                                                },
                                                child: Image.asset(
                                                  AppImages.lockIcon,
                                                  height: 30,
                                                )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(28),
                                              bottomRight: Radius.circular(28)),
                                          color: openTime <= current_time &&
                                                      closeTime >=
                                                          current_time ||
                                                  day + "_status" == "active"
                                              ? AppColor.neon
                                              : Colors.red),
                                      child: Center(
                                        child: Text(
                                          openTime <= current_time &&
                                                      closeTime >=
                                                          current_time ||
                                                  day + "_status" == "active"
                                              ? "Running"
                                              : "Closed",
                                          style: TextStyle(
                                              color: openTime <= current_time &&
                                                          closeTime >=
                                                              current_time ||
                                                      day + "_status" ==
                                                          "active"
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontFamily:
                                                  AppFont.poppinsSemiBold),
                                        ),
                                      ))
                                ],
                              ),
                            )

                            // ListTile(
                            //   horizontalTitleGap: 5,
                            //   onTap: openTime <= current_time &&
                            //               closeTime >= current_time ||
                            //           day + "_status" == "active"
                            //       ? () {
                            //           print("game name ${gameList?[index].name}");
                            //           Navigator.pushNamed(
                            //               context, AppScreen.supremeDay,
                            //               arguments: {
                            //                 "points": dashboardData.wallet,
                            //                 "gameName": gameList?[index].name
                            //               });
                            //         }
                            //       : () {
                            //           showToast(
                            //               "Currently market is closed now, when the market will open, then you invest your money in this market, please wait.");
                            //         },
                            //   contentPadding: EdgeInsets.symmetric(
                            //       vertical: 15, horizontal: 15),
                            //   tileColor: AppColor.white,
                            //   leading: Container(
                            //     height: 51,
                            //     width: 51,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(20),
                            //         gradient: AppColor.yellowGradient),
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.person,
                            //         size: 45,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(30)),
                            //   title: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             gameList?[index].name ?? "",
                            //             style: TextStyle(
                            //                 color: AppColor.black,
                            //                 fontSize: 14,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 fontFamily: AppFont.poppinsSemiBold),
                            //           ),
                            //           Text(
                            //             openTime <= current_time &&
                            //                         closeTime >= current_time ||
                            //                     day + "_status" == "active"
                            //                 ? "Running"
                            //                 : "Closed",
                            //             style: TextStyle(
                            //                 color: openTime <= current_time &&
                            //                             closeTime >=
                            //                                 current_time ||
                            //                         day + "_status" == "active"
                            //                     ? AppColor.neon
                            //                     : Colors.red,
                            //                 fontSize: 14,
                            //                 fontFamily: AppFont.poppinsSemiBold),
                            //           )
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         height: 5,
                            //       ),
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             "${formattedOpenTime} - ${formattedCloseTime}",
                            //             style: TextStyle(
                            //                 color: AppColor.black,
                            //                 fontSize: 14,
                            //                 fontFamily: AppFont.poppinsMedium),
                            //           ),
                            //           Text(
                            //             gameList?[index].winningNumber ?? "",
                            //             style: TextStyle(
                            //                 color: AppColor.black,
                            //                 fontSize: 14,
                            //                 fontFamily: AppFont.poppinsMedium),
                            //           )
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return tryAgain(onTap: () => setState(() {}));
        }
        return shimmerEffect();
      },
    ));
  }

  Widget customCard(
      {required Widget icon,
      required String iconName,
      void Function()? onTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppColor.customWhite,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            // SizedBox(
            //   width: 5,
            // ),
            Text(
              iconName,
              style: TextStyle(fontFamily: AppFont.poppinsSemiBold),
            )
          ],
        ),
      ),
    ));
  }

  openWhatsApp() async {
    var whatsapp = "+919144040888";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
        await launchUrl(Uri.parse(whatsappURL_ios));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
        await launchUrl(Uri.parse(whatsappURl_android));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp not installed")));
      }
    }
  }
}
