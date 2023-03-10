import 'package:dp_boss/API%20Response%20Model/Transaction%20History%20Model/transaction_history_model.dart';
import 'package:dp_boss/Providers/Transaction%20History%20Provider/transaction_history_provider.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Component/icon_card.dart';
import '../../Component/shimmer.dart';
import '../../Component/try_again.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/date_time_converter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Future getRefreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TransactionHistoryProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, AppScreen.dashboard,
            arguments: {'key': 'Home'});
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            children: [
              button(
                onPressed: () {
                  Navigator.pushNamed(context, AppScreen.withdrawalScreen);
                },
                buttonText: "Withdraw",
                icon: SvgPicture.asset(AppImages.withdrawalIcon1),
              ),
              SizedBox(
                width: 10,
              ),
              button(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var upiId = prefs.getString("upiId");
                  Navigator.pushNamed(context, AppScreen.depositScreen,
                      arguments: {"upiId": upiId});
                },
                buttonText: "Deposit",
                icon: SvgPicture.asset(AppImages.depositIcon1),
              )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: iconCard(
              icon: SvgPicture.asset(AppImages.backIcon),
              onPressed: () {
                Navigator.popAndPushNamed(context, AppScreen.dashboard,
                    arguments: {'key': 'Home'});
              }),
          title: Text(
            "Wallet",
            style: TextStyle(
                fontFamily: AppFont.poppinsMedium,
                fontSize: 14,
                color: AppColor.black),
          ),
          actions: [
            iconCard(
                icon: Text(
                  "Pt",
                  style: TextStyle(color: AppColor.white, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppScreen.pointsScreen);
                }),
            SizedBox(
              width: 12,
            )
          ],
        ),
        body: FutureBuilder(
            future: provider.transactionHistory(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var transactionHistory =
                      snapshot.data as TransactionHistoryModel;
                  // var descendingOrder = transactionHistory.reversed.toList();
                  var transactionHistoryList =
                      transactionHistory.data?.reversed.toList();
                  return RefreshIndicator(
                      color: AppColor.lightYellow,
                      onRefresh: getRefreshData,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          Container(
                            height: 173,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                    image: AssetImage(AppImages.walletCard),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    "Current Balance",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsMedium),
                                  ),
                                  Text.rich(TextSpan(
                                      text: "???",
                                      style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 34,
                                          color: Colors.white,
                                          fontFamily: AppFont.poppinsSemiBold),
                                      children: [
                                        TextSpan(
                                          text: transactionHistory.wallet,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 34,
                                              fontFamily: AppFont.poppinsBold),
                                        )
                                      ])),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Transaction History",
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 16,
                                      fontFamily: AppFont.poppinsSemiBold,
                                    )),
                                Text(
                                  "All",
                                  style: TextStyle(
                                      color: AppColor.customGrey,
                                      fontSize: 14,
                                      fontFamily: AppFont.poppinsSemiBold),
                                )
                              ],
                            ),
                          ),
                          transactionHistoryList!.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: kBottomNavigationBarHeight + 20),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                  itemCount: transactionHistoryList.length,
                                  itemBuilder: (context, index) {
                                    var transactionDate =
                                        extractDateFromDateTime(
                                            transactionHistoryList[index]
                                                    .createdAt ??
                                                "",
                                            "d MMM y");
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minLeadingWidth: 0,
                                      horizontalTitleGap: 5,
                                      leading: Container(
                                        height: 51,
                                        width: 51,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: AppColor.yellowGradient),
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 37,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                transactionHistoryList[index]
                                                            .transactionType ==
                                                        "CR"
                                                    ? "Credit"
                                                    : "Deposit",
                                                style: TextStyle(
                                                    color: AppColor.black,
                                                    fontFamily:
                                                        AppFont.poppinsSemiBold,
                                                    fontSize: 14),
                                              ),
                                              Spacer(),
                                              transactionHistoryList[index]
                                                          .transactionType ==
                                                      "CR"
                                                  ? SvgPicture.asset(
                                                      AppImages.creditIcon)
                                                  : SvgPicture.asset(
                                                      AppImages.debitIcon),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                "???${transactionHistoryList[index].transactionAmt}",
                                                style: TextStyle(
                                                    color: AppColor.black,
                                                    fontFamily:
                                                        AppFont.poppinsSemiBold,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                transactionHistoryList[index]
                                                        .transactionTitle ??
                                                    "",
                                                style: TextStyle(
                                                    color: AppColor.darkGrey,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppFont.poppinsRegular),
                                              ),
                                              Text(transactionDate,
                                                  style: TextStyle(
                                                      color: AppColor.darkGrey,
                                                      fontSize: 14,
                                                      fontFamily: AppFont
                                                          .poppinsRegular))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "No Transaction History",
                                    style: TextStyle(
                                        fontFamily: AppFont.poppinsSemiBold),
                                  ),
                                )
                        ],
                      ));
                } else {
                  return tryAgain(onTap: () => setState(() {}));
                }
              }
              return shimmerEffect(isHomePageShimmer: false);
            }),
      ),
    );
  }

  Widget button(
      {required void Function()? onPressed,
      required String buttonText,
      required Widget icon}) {
    return Expanded(
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.lightYellow2),
              elevation: MaterialStateProperty.all<double?>(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ))),
          child: Container(
            width: AppSize.getWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  width: 4,
                ),
                Text(
                  buttonText,
                  style: TextStyle(color: AppColor.black, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }
}
