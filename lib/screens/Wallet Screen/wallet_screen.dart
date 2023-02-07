import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            button(
                onPressed: (){},
                buttonText: "Withdraw",
              icon: SvgPicture.asset(AppImages.withdrawalIcon1),),
            SizedBox(width: 10,),
            button(
              onPressed: (){},
              buttonText: "Deposit",
              icon: SvgPicture.asset(AppImages.depositIcon1),)
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Wallet",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            height: 173,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red,
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
          )
        ],
      ),
    );
  }

  Widget button({required void Function()? onPressed,
    required String buttonText, required Widget icon
  }) {
    return Expanded(
      child: ElevatedButton(
          onPressed: () {},
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
