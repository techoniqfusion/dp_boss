import 'package:dp_boss/Component/my_shimmer.dart';
import 'package:dp_boss/utils/date_time_converter.dart';
import 'package:dp_boss/utils/string_capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../API Response Model/Support History All Data/support_history_all_data_model.dart';
import '../../Component/custom_button.dart';
import '../../Component/icon_card.dart';
import '../../Component/try_again.dart';
import '../../Providers/Support History All Data Provider/support_history_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {

  Future getRefreshData() async{
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupportHistoryProvider>(context,listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: CustomButton(
          backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
          buttonText: "+ Create Now",
          textColor: Colors.black,
          onPressed: (){
            Navigator.popAndPushNamed(context, AppScreen.createRequest);
          },
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Help & Support",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: FutureBuilder(
          future: provider.supportHistory(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<SupportHistoryModel> historyData = snapshot.data as List<SupportHistoryModel>;
                var descendingOrder = historyData.reversed.toList();
                // print("History data is ${historyData.first.subject}");
                return RefreshIndicator(
                  color: AppColor.lightYellow,
                  onRefresh: getRefreshData,
                  child: historyData.isNotEmpty ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    itemCount: descendingOrder.length,
                    itemBuilder: (context, index) {
                      var requestDate = DateTime.parse(descendingOrder[index].createdAt ?? "");
                      var formattedTime = DateFormat.jm().format(requestDate);
                      var formattedDate = extractDateFromDateTime(descendingOrder[index].createdAt ?? "", "d, MMM, y");
                      return GestureDetector(
                        onTap: (){
                          print("Support id => ${historyData[index].id}");
                          Navigator.pushNamed(context, AppScreen.chatScreen, arguments: {"supportId":historyData[index].id});
                        },
                        child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            decoration: BoxDecoration(
                                color: AppColor.customWhite,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(descendingOrder[index].subject.toString(),style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.poppinsSemiBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),),

                                      Text("${formattedDate} | ${formattedTime}",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),), //12th, Dec, 2022 | 09:00 AM"

                                      SizedBox(height: 10,),

                                      Text(descendingOrder[index].message.toString(),style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: AppFont.poppinsSemiBold,
                                      ),)
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(descendingOrder[index].status!.capitalize(),style: TextStyle(
                                        color: AppColor.green,
                                        fontSize: 14,fontFamily: AppFont.poppinsSemiBold
                                    ),),
                                    // Text("Resolve",style: TextStyle(
                                    //     color: Colors.grey,
                                    //     fontSize: 12,
                                    //     fontFamily: AppFont.poppinsSemiBold
                                    // ),)
                                  ],
                                ),
                              ],
                            )
                        ),
                      );
                    },) :
                  Center(child: Text("No request is created yet",style: TextStyle(
                      fontFamily: AppFont.poppinsSemiBold
                  ),),),
                );
              }
              else {
                return tryAgain(
                    onTap: () => setState(() {}));
              }
            }
            return myShimmer();
          }
      ),
    );
  }
}
