import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_share/social_share.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';
import '../../utils/show_toast.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {

  final formKey = GlobalKey<FormState>();
  var referralAmountController = TextEditingController();

  @override
  void dispose() {
    referralAmountController.dispose();
    super.dispose();
  }

  String? validate(String? value) {
    if (value!.isEmpty) {
      return "Required";
    }
    return null;
  }

  Future getRefresh() async{
    setState(() {});
  }
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
          "Refer & Earn",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: RefreshIndicator(
      color: AppColor.lightYellow,
      onRefresh: getRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Total referral amount",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(TextSpan(
                  text: "₹",
                  style: TextStyle(
                    // letterSpacing: 0.5,
                      fontSize: 27.49,
                      color: AppColor.black,
                      fontFamily: AppFont.poppinsSemiBold),
                  children: [
                    TextSpan(
                      text: "500",
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 42,
                          fontFamily: AppFont.poppinsBold),
                    )
                  ])),
              CustomButton(
                radius: 30,
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(width: 1, color: Colors.red)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.lightYellow),
                buttonText: "Claim Now",
                textColor: Colors.black,
                onPressed: (){
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: formKey,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: const Text('Enter Referral Amount'),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20,),
                                  CustomTextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9]"),
                                      )
                                    ],
                                    validator: validate,
                                    controller: referralAmountController,
                                    // padding: EdgeInsets.only(bottom: 20, top: 10),
                                    hintText: "Enter Referral Amount",
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    CustomButton(
                                      height: 20,
                                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
                                      buttonText: 'Claim Amount',
                                      onPressed: () async {
                                        formKey.currentState!.validate();
                                        var data = FormData.fromMap({
                                          "amount" : referralAmountController.text
                                        });
                                        // final response = await appApi.claimAmountApi(body: data);
                                        // if(referralAmountController.text.isNotEmpty){
                                        //   if(response.data['status']){
                                        //     Navigator.pop(context);
                                        //     showDialog(
                                        //       barrierDismissible: false,
                                        //       context: context,
                                        //       builder: (context) => CupertinoAlertDialog(
                                        //         title: Text(response.data['message'],textAlign: TextAlign.center,),
                                        //         actions: [
                                        //           TextButton(
                                        //             onPressed: () {
                                        //               Navigator.of(context).pop();
                                        //               referralAmountController.clear();
                                        //               setState(() {});
                                        //             },
                                        //             child: const Text("okay"),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     );
                                        //   }
                                        //   else{
                                        //     popUp(context: context,
                                        //       title: response.data['message'],
                                        //       actions: [
                                        //         TextButton(
                                        //           onPressed: () {
                                        //             Navigator.of(context).pop();
                                        //             referralAmountController.clear();
                                        //           },
                                        //           child: const Text("okay"),
                                        //         ),
                                        //       ],
                                        //     );
                                        //   }
                                        // }
                                      },
                                    ),
                                    SizedBox(width: 10,),
                                    CustomButton(
                                      height: 20,
                                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
                                      buttonText: 'Cancel',
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Image.asset(
              AppImages.offer,
              width: AppSize.getWidth(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              "Invite",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 50.0, right: 50, bottom: 60),
            child: Text(
              textAlign: TextAlign.center,
              "share your referral code with your friends and get benefits",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: "refer"));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                  backgroundColor: AppColor.white,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Copy to Clipboard",
                    style: TextStyle(
                        color: AppColor.darkGrey,
                        fontFamily: AppFont.poppinsSemiBold),
                  ),
                ));
              },
              child: DottedBorder(
                dashPattern: [7, 5, 0, 0],
                // borderPadding: EdgeInsets.symmetric(horizontal: 10),
                borderType: BorderType.RRect,
                radius: Radius.circular(6),
                padding: EdgeInsets.all(6),
                strokeWidth: 1.5,
                // color: Colors.black,
                child: Container(
                    padding: EdgeInsets.all(8),
                    // height: 35,
                    //  width: AppSize.getWidth(context),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                             "refer code",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Icon(
                          Icons.copy,
                          color: Colors.grey,
                        )
                      ],
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () async {
                      // print("on whatsapp tap");
                      var res = await SocialShare.shareWhatsapp("refer link");
                      print(
                          "res from whatsapp share => $res"); //error, success
                      if (res == "error") {
                        showToast("App is not available");
                      }
                    },
                    child: Image.asset(
                      AppImages.whatsApp,
                      height: 59,
                    )),
                GestureDetector(
                    onTap: () {
                      SocialShare.shareTwitter("refer link",
                      );
                    },
                    child: Image.asset(
                      AppImages.twitter,
                      height: 59,
                    )),
                GestureDetector(
                    onTap: () async {
                      await SocialShare.shareOptions(
                          "refer link")
                          .catchError((onError) {
                            return onError;
                      });
                    },
                    child: Image.asset(
                      AppImages.more,
                      height: 59,
                    )),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            indent: 15,
            endIndent: 15,
            thickness: 1,
          ),
          SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text("Referral History")),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "referrals")),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                minLeadingWidth: 0,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: AppColor.lightYellow,
                      shape: BoxShape.circle),
                  child: Center(
                    child: Text("N/A" ,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColor.black,
                          fontFamily: AppFont.poppinsSemiBold),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "N/A",
                      style: TextStyle(
                          color: AppColor.black,
                          fontFamily: AppFont.poppinsSemiBold),
                    ),
                    Text(
                      "Mobile",
                      style: TextStyle(
                          color: AppColor.black, fontSize: 12),
                    )
                  ],
                ),
                trailing: Text(
                  "updated at",
                  style: TextStyle(
                      color: AppColor.black,
                      fontFamily: AppFont.poppinsSemiBold),
                ), //"Joined 5th, DEC,2022"
              );
            },
          )
        ],
      ),
    ),
    );
  }
}
