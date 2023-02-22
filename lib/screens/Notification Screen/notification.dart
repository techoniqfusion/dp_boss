import 'package:dp_boss/Component/my_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Component/icon_card.dart';
import '../../Component/try_again.dart';
import '../../Providers/Notification Provider/notification_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/date_time_converter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  Future getRefreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
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
          "Notification",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: FutureBuilder(
          future: provider.notificationCall(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var notificationList = snapshot.data;
                return notificationList!.isNotEmpty
                    ? RefreshIndicator(
                  color: AppColor.lightYellow,
                  onRefresh: getRefreshData,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var requestDate = DateTime.parse(notificationList[index].createdAt ?? "");
                            var formattedTime = DateFormat.jm().format(requestDate);
                            var formattedDate = extractDateFromDateTime(notificationList[index].createdAt ?? "", "d, MMM, yy");
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  iconCard(
                                    icon: SvgPicture.asset(
                                        AppImages.notificationIcon),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notificationList[index].title ?? "",
                                          style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            notificationList[index].message ?? "",
                                          style: TextStyle(
                                              color: AppColor.customGrey),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text("${formattedDate}",style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 3,),
                                      Text("${formattedTime}",style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    )
                    : Center(
                        child: Image.asset(AppImages.zeroNotification,height: 179,),
                      );
              } else {
                return tryAgain(onTap: () {
                  setState((){});
                });
              }
            }
            return myShimmer();
          }),
    );
  }
}
