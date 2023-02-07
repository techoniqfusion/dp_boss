import 'package:dp_boss/utils/app_color.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/app_route.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bank Account",
            style: TextStyle(
              color: AppColor.black,
              fontFamily: AppFont.poppinsSemiBold,
              fontSize: 16,
            ),
          ),
          Text(
            "Setup Bank Account",
            style: TextStyle(color: AppColor.black, fontSize: 14),
          ),
          SizedBox(height: 10,),
          addAccountTile(text: "Add New Bank Account",onPressed: (){
            Navigator.pushNamed(context, AppScreen.addBankAccount);
          }),
          SizedBox(height: 10,),
          Text(
            "UPI",
            style: TextStyle(
              color: AppColor.black,
              fontFamily: AppFont.poppinsSemiBold,
              fontSize: 16,
            ),
          ),
          Text(
            "Setup your UPI ID for secure payment",
            style: TextStyle(color: AppColor.black, fontSize: 14),
          ),
          ListTile(
            leading: Image.asset(
              AppImages.paytmIcon,
              height: 9,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Paytm",
                  style: TextStyle(color: AppColor.black, fontSize: 14),
                ),
                Text(
                  "******789",
                  style: TextStyle(color: AppColor.black),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              AppImages.googlePayIcon,
              height: 20,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Google Pay",
                  style: TextStyle(color: AppColor.black, fontSize: 14),
                ),
                Text(
                  "******789",
                  style: TextStyle(color: AppColor.black),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              AppImages.phonePeIcon,
              height: 20,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Pay",
                  style: TextStyle(color: AppColor.black, fontSize: 14),
                ),
                Text(
                  "******789",
                  style: TextStyle(color: AppColor.black),
                ),
              ],
            ),
          ),
         addAccountTile(text: "Add new UPI ID")
        ],
      ),
    ));
  }

  Widget addAccountTile({void Function()? onPressed, required String text}){
    return ListTile(
      onTap: onPressed,
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColor.lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
            onPressed: onPressed,
            icon: const Text(
              "+",
              style: TextStyle(color: AppColor.black,fontFamily: AppFont.poppinsSemiBold),
            )),
      ),
      title: Text(
        text,
        style: const TextStyle(color: AppColor.black, fontSize: 14, fontFamily: AppFont.poppinsSemiBold),
      ),
    );
  }
}
