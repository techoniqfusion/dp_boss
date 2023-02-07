import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          "Notification",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                children: [
                  iconCard(icon: SvgPicture.asset(AppImages.notificationIcon),),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("New Update",style: TextStyle(color: AppColor.black,fontSize: 14),),
                        SizedBox(height: 2,),
                        Text("There is a latest update of the application.Update Now",style: TextStyle(
                            color: AppColor.customGrey
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            );
          },)
    );
  }
}
