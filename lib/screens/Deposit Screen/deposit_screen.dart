import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/textheading.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';

class DepositScreen extends StatefulWidget {
  final String? upiId;
  const DepositScreen({Key? key, this.upiId}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  var amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("upi id ${widget.upiId}");
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          "Deposit Amount",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushNamedAndRemoveUntil(context, AppScreen.dashboard,
              //         (route) => false,
              //     arguments: {'key' : 'Account'});
            }),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          SizedBox(
            height: 15,
          ),
          textHeading(text: "Enter Amount"),
          Form(
            key: formKey,
            child: CustomTextField(
              controller: amountController,
              validator: Validation.validate,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"\d"), // allow only numbers
                )
              ],
              hintText: "Enter Amount",
              horizontalContentPadding: 30,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            buttonText: "Deposit Now",
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.lightYellow),
            onPressed: () {
              var isValidate = formKey.currentState?.validate();
              if (isValidate != null && isValidate == true) {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, AppScreen.depositSummary,
                    arguments: {
                      "upiId": widget.upiId,
                      "amount": amountController.text
                    });
              }
              // if(amountController.text.isEmpty){
              //   popUp(context: context, title: "Please enter amount", actions: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         child: Text("Okay"))
              //   ]);
              // }
            },
          ),
        ],
      ),
    );
  }
}
