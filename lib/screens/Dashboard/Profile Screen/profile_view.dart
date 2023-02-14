import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../API Response Model/Registration Model/registration_model.dart';
import '../../../Component/icon_card.dart';
import '../../../Component/pop_up.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/db_helper.dart';
import '../../../utils/logout_user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  var sqliteDb = SQLService();
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    // setState(() {
    getUserData()
        .then((value) => {if (value != null && value != "null"){
          userName = value.name,
          userEmail = value.email
    }});
    // });
  }

  Future getUserData() async {
    await sqliteDb.openDB();
    try {
      List list = await sqliteDb.getUser();
      final data = UserData.fromJson(list.first);
      // print("function Called!!..");
      setState(() {
        userName = data.name!;
        userEmail = data.email!;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("user name $userName");
    print("user name $userEmail");
    var fontStyle =  const TextStyle(
        color: AppColor.black,fontSize: 14,
        fontFamily: AppFont.poppinsMedium);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              // clipBehavior: Clip.hardEdge,
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.yellow,
                  width: 2
                )
              ),
              child:
              ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: Image.asset(AppImages.avatar)),
            ),
            SizedBox(height: 10,),
            Text(userName,style: TextStyle(
              color: AppColor.black,fontSize: 14,
              fontFamily: AppFont.poppinsSemiBold
            ),),
            Text(userEmail != "null" ? userEmail : "",style: TextStyle(
                color: AppColor.black.withOpacity(0.9),fontSize: 14,
                fontFamily: AppFont.poppinsMedium
            ),),
            SizedBox(height: 10,),
            CustomButton(
                radius: 13,
              height: 39,
                width: 140,
                buttonText: "Edit",
                backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
                textColor: AppColor.black,
              onPressed: (){
                  Navigator.pushNamed(context, AppScreen.editProfile);
              },
            ),
            SizedBox(height: 10,),
            Divider(
              color: AppColor.lightYellow,
            ),
            listTile(
                title: Text("Game Rate",style: fontStyle,),
                leading: Image.asset(AppImages.gameRateIcon,height: 40),
                onPressed: (){}),
            listTile(
                title: Text("Refer & Earn",style: fontStyle,),
                leading: Image.asset(AppImages.referEarnIcon,height: 40),
                onPressed: (){
                  Navigator.pushNamed(context, AppScreen.referAndEarn);
                }),
            listTile(
              title: Row(
                children: [
                  iconCard(
                      icon: Icon(Icons.verified_user,color: Colors.white,),
                      height: 40,width: 40,
                      radius: 15
                  ),
                  SizedBox(width: 18,),
                  Text("Verify", style: const TextStyle(
                      color: AppColor.black,fontSize: 14,
                      fontFamily: AppFont.poppinsMedium
                  ),)
                ],
              ),
              onPressed: (){
                Navigator.pushNamed(context, AppScreen.verifyScreen);
              }
            ),

            listTile(
                title: Row(
                  children: [
                    iconCard(
                        icon: Icon(Icons.help,color: Colors.white,),
                        height: 40,width: 40,
                        radius: 15
                    ),
                    SizedBox(width: 18,),
                    Text("Help & Support", style: const TextStyle(
                        color: AppColor.black,fontSize: 14,
                        fontFamily: AppFont.poppinsMedium
                    ),)
                  ],
                ),
                onPressed: (){
                  Navigator.pushNamed(context, AppScreen.helpAndSupport);
                }
            ),

            listTile(
                title: Text("Logout",style: fontStyle,),
                leading: Image.asset(AppImages.logOutIcon,height: 40),
                onPressed: (){
                  popUp(
                      context: context,
                      title: "Are you sure?",
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            LogOutUser.logout(context);
                          },
                          child: Text("logout"),
                        ),
                      ]);
                })
          ],
        ),
      )
    );
  }

    Widget listTile({Widget? leading, required Widget title,required void Function()? onPressed}){
          return ListTile(
            onTap: onPressed,
            leading: leading,
            title: title,
            trailing: IconButton(
              onPressed: onPressed,
              icon: SvgPicture.asset(AppImages.forwardIcon),
            ),
          );
    }
}
