import 'package:dio/dio.dart';
import 'package:dp_boss/Providers/Recover%20Password%20Provider/recover_password_provider.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';
import '../../utils/validation.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoverPasswordProvider>(context,listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height + 100, bottom: 100),
                child: Image.asset(AppImages.logo),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Recover Password",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontFamily: AppFont.poppinsSemiBold),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "We will send you a verification code",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontFamily: AppFont.poppinsRegular),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "+91",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.customGrey,
                        fontFamily: AppFont.poppinsRegular,
                        fontSize: 14),
                  ),
                ),
                validator: Validation.validateMobile,
                // onChanged: (val) {
                //   if (val.length == 10) {
                //     FocusScope.of(context).unfocus(); // disable keyboard
                //   }
                // },
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[0-9]"), // allow only numbers
                  )
                ],
                keyboardType: TextInputType.number,
                controller: mobileNumberController,
              ),

              SizedBox(
                height: 20 + kBottomNavigationBarHeight,
              ),
              // SizedBox(height: 20,),

              CustomButton(
                onPressed: () async{
                  formKey.currentState?.validate();
                  if(mobileNumberController.text.isNotEmpty){
                    // FocusScope.of(context).unfocus();
                    var formData = FormData.fromMap({
                      "phone" : mobileNumberController.text
                    });
                    final response = await provider.recoverPassword(context, formData);
                    if(response['status_code'] == 200){
                      Navigator.pushNamed(context, AppScreen.otpScreen,
                          arguments: {'isRecoverPassword': true,
                            'mobile': mobileNumberController.text,
                            'isAppClosed': true
                          });
                    }
                  }
                },
                width: AppSize.getWidth(context),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.lightYellow),
                buttonText: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
