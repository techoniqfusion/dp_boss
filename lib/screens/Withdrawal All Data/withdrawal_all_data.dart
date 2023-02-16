import 'package:dp_boss/API%20Response%20Model/Withdrawal%20All%20Data%20Model/withdrawal_all_data_model.dart';
import 'package:dp_boss/Providers/Withdrawal%20All%20Data%20Provider/withdrawal_all_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Component/icon_card.dart';
import '../../Component/my_shimmer.dart';
import '../../Component/try_again.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/date_time_converter.dart';

class WithdrawalAllData extends StatefulWidget {
  const WithdrawalAllData({Key? key}) : super(key: key);

  @override
  State<WithdrawalAllData> createState() => _WithdrawalAllDataState();
}

class _WithdrawalAllDataState extends State<WithdrawalAllData> {
  Future getRefreshData() async {
    setState(() {});
  }

  var fontStyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      color: AppColor.black,
      fontSize: 14);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WithdrawalAllDataProvider>(context, listen: false);
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
          "Withdrawal All",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: FutureBuilder(
          future: provider.withdrawalAllData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final withdrawalAllDataList =
                    snapshot.data as List<WithdrawalAllDataModel>;
                var withdrawalList = withdrawalAllDataList.reversed.toList();
                // print("History data is ${historyData.first.subject}");
                return RefreshIndicator(
                  color: AppColor.lightYellow,
                  onRefresh: getRefreshData,
                  child: withdrawalList.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          itemCount: withdrawalList.length,
                          itemBuilder: (context, index) {
                            var requestDate = DateTime.parse(
                                withdrawalList[index].createdAt ?? "");
                            var formattedTime =
                                DateFormat.jm().format(requestDate);
                            var formattedDate = extractDateFromDateTime(
                                withdrawalList[index].createdAt ?? "",
                                "d, MMM, y");
                            return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 12),
                                decoration: BoxDecoration(
                                    color: AppColor.customWhite,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Withdrawal Date: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                                  AppFont.poppinsSemiBold),
                                        ),
                                        Text(
                                          "${formattedDate} | ${formattedTime}",
                                          style: fontStyle,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                              AppFont.poppinsSemiBold),
                                        ),
                                        Text(
                                          withdrawalList[index]
                                                  .withdrawalAmount ??
                                              "",
                                          style: fontStyle
                                        )
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Bank: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                              AppFont.poppinsSemiBold),
                                        ),
                                        Text(withdrawalList[index]
                                            .bankName ??
                                            "",style: fontStyle,)
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Account Number: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                              AppFont.poppinsSemiBold),
                                        ),
                                        Text(withdrawalList[index]
                                            .accountNumber ??
                                            "",style: fontStyle,)
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "IFSC Code: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                              AppFont.poppinsSemiBold),
                                        ),
                                        Text(withdrawalList[index]
                                            .accountIfscCode ??
                                            "",style: fontStyle,)
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Status: ",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14,
                                              fontFamily:
                                              AppFont.poppinsSemiBold),
                                        ),
                                        Text(withdrawalList[index].withdrawalStatus ??
                                            "",style: TextStyle(
                                            color: withdrawalList[index].withdrawalStatus == "Success" ? Colors.green :
                                            withdrawalList[index].withdrawalStatus == "Pending" ? AppColor.yellow :
                                            Colors.red,fontSize: 14,
                                            fontFamily: AppFont.poppinsSemiBold
                                        ),)
                                      ],
                                    )
                                  ],
                                ));
                          },
                        )
                      : Center(
                          child: Text(
                            "No Withdrawal History",
                            style:
                                TextStyle(fontFamily: AppFont.poppinsSemiBold),
                          ),
                        ),
                );
              } else {
                return tryAgain(onTap: () => setState(() {}));
              }
            }
            return myShimmer(height: 125);
          }),
    );
  }
}
