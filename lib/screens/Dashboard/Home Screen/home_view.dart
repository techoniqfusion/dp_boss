import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Scaffold(
        body: SingleChildScrollView(
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
                            text: "1000.00",
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
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: Image.asset(AppImages.gameCard)
                  ),
                  Positioned(
                    left: 25,
                    bottom: 18,
                    child: CustomButton(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.yellow1.withOpacity(0.4)),
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
              ListView.builder(
                padding: EdgeInsets.only(top: 10,bottom: kBottomNavigationBarHeight + 20),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kuber Morning",
                                style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.poppinsSemiBold),
                              ),
                              Text(
                                "Running",
                                style: TextStyle(
                                    color: AppColor.neon,
                                    fontSize: 14,
                                    fontFamily: AppFont.poppinsMedium),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "09:00 AM - 10:00 PM",
                                style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.poppinsMedium),
                              ),
                              Text(
                                "000-04-888",
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
              )
            ],
          ),
        ));
  }
}
