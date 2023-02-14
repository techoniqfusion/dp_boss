import 'package:dio/dio.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/textheading.dart';
import 'package:dp_boss/Providers/Points%20Provider/points_provider.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  var receiverMobileNoController = TextEditingController();
  var amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    receiverMobileNoController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PointsTransferProvider>(context,listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
        child: CustomButton(
          isLoading: context.watch<PointsTransferProvider>().buttonLoader,
          backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
          buttonText: "Submit",
          onPressed: () async{
            var isValidate = formKey.currentState?.validate();
            // print("on tap 0");
            if (isValidate != null && isValidate == true){
              var formData = FormData.fromMap({
                "phone_number" : receiverMobileNoController.text,
                "amount" : amountController.text
              });
              var response = await provider.pointsTransfer(context, formData);
              // if(response['status'] == true || response['status_code'] == 201){
              //   receiverMobileNoController.clear();
              //   amountController.clear();
              // }
            }
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
          "Points",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(height: 20,),
            textHeading(text: "Receiver Mobile Number"),
            CustomTextField(
              validator: Validation.validateMobile,
              maxLength: 10,
              controller: receiverMobileNoController,
              horizontalContentPadding: 30,
              hintText: "Receiver Mobile Number",
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"\d"), // allow only numbers
                )
              ],
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20,),
            textHeading(text: "Enter Amount"),
            CustomTextField(
              validator: Validation.validate,
              // maxLength: 10,
              controller: amountController,
              horizontalContentPadding: 30,
              hintText: "Amount",
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"\d"), // allow only numbers
                )
              ],
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}
