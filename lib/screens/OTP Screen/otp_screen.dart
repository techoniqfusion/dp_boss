import 'package:dio/dio.dart';
import 'package:dp_boss/Component/otp_textfield.dart';
import 'package:dp_boss/Providers/Recover%20Password%20Provider/recover_password_provider.dart';
import 'package:dp_boss/Providers/Registration%20Provider/registration_provider.dart';
import 'package:dp_boss/utils/replace_char.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Component/custom_button.dart';
import '../../Providers/Auth Provider/auth_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/app_size.dart';

class OtpScreen extends StatefulWidget {
  String mobileNumber;
  bool isAppClosed;
  bool isRecoverPassword;
  OtpScreen(
      {Key? key,
      this.mobileNumber = '',
      this.isAppClosed = false,
      this.isRecoverPassword = false})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  var mobileNo = '';

  @override
  void initState() {
    context.read<AuthProvider>().startTimer();
    getMobileNumber().then((value) {
      // widget.mobileNumber = value ?? "";
      // print("mobile number $value");
      // print("widget.isAppClosed  value => ${widget.isAppClosed}");
      if (widget.isAppClosed == false) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        var formData = FormData.fromMap({"phone": value});
        authProvider.sendOtp(context, formData);
      }
      setState(() {
        mobileNo = value ?? "";
      });
    });
    super.initState();
    print("mobile number ${widget.mobileNumber}");
  }

  Future<String?> getMobileNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("mobileNumber");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final recoverPassProvider =
        Provider.of<RecoverPasswordProvider>(context, listen: false);
    String maskMobileNumber =
        widget.isRecoverPassword ? widget.mobileNumber : mobileNo;
    for (int i = 4; i < maskMobileNumber.length; i++) {
      maskMobileNumber = replaceCharAt(maskMobileNumber, i, "*");
    }
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                widget.isRecoverPassword
                    ? "Recover Password"
                    : "OTP Verification",
                style: const TextStyle(
                    color: AppColor.black,
                    fontSize: 20,
                    fontFamily: AppFont.poppinsSemiBold),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "A six digit code sent to +91 $maskMobileNumber",
                style: const TextStyle(
                    color: AppColor.black,
                    fontSize: 14,
                    fontFamily: AppFont.poppinsRegular),
              ),
            ),

            SizedBox(
              height: 40,
            ),

            OtpTextField(otpController: otpController),
            // PinCodeTextField(
            //   appContext: context,
            //   pastedTextStyle: TextStyle(
            //     color: Colors.green.shade600,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   length: 6,
            //   // obscureText: true,
            //   // obscuringCharacter: '*',
            //   // obscuringWidget: const FlutterLogo(
            //   //   size: 24,
            //   // ),
            //   inputFormatters: [
            //     FilteringTextInputFormatter.allow(
            //       RegExp(r"[0-9]"),
            //     )
            //   ],
            //   blinkWhenObscuring: true,
            //   animationType: AnimationType.fade,
            //   pinTheme: PinTheme(
            //     activeColor: AppColor.white,
            //     selectedColor: AppColor.grey1,
            //     inactiveFillColor: AppColor.white,
            //     disabledColor: AppColor.white,
            //     selectedFillColor: AppColor.white,
            //     shape: PinCodeFieldShape.box,
            //     errorBorderColor: AppColor.white,
            //     inactiveColor: AppColor.grey1,
            //     borderWidth: 1,
            //     borderRadius: BorderRadius.circular(10),
            //     fieldHeight: 53,
            //     fieldWidth: 50,
            //     activeFillColor: Colors.white,
            //   ),
            //   cursorColor: Colors.black,
            //   animationDuration: const Duration(milliseconds: 300),
            //   enableActiveFill: true,
            //   // errorAnimationController: errorController,
            //   controller: otpController,
            //   keyboardType: TextInputType.number,
            //   // boxShadows: const [
            //   //   BoxShadow(
            //   //     offset: Offset(0, 1),
            //   //     color: Colors.black12,
            //   //     blurRadius: 10,
            //   //   )
            //   // ],
            //   onCompleted: (val) async {
            //     // print("OTP ${val}");
            //     // if (otpController.text.isNotEmpty) {
            //     //   var data =
            //     //   await authProvider.verifyOTP(context, formData);
            //     //   print("response data value is ${data['message']}");
            //     //   if (!data['status'] && data['status_code'] == 201) {
            //     //     otpController.clear();
            //     //   }
            //     // }
            //   },
            //   // onTap: () {
            //   //   print("Pressed");
            //   // },
            //   onChanged: (value) {},
            //   beforeTextPaste: (text) {
            //     debugPrint("Allowing to paste $text");
            //     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //     //but you can show anything you want here, like your pop up saying wrong paste format or etc
            //     return true;
            //   },
            // ),

            Visibility(
              visible: context.watch<AuthProvider>().start != 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Auto fetching OTP",
                    style: TextStyle(
                        color: AppColor.customGrey,
                        fontFamily: AppFont.poppinsRegular),
                  ),
                  Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                    return Text(
                      "${context.watch<AuthProvider>().start} SEC",
                      style: TextStyle(
                          fontFamily: AppFont.poppinsSemiBold,
                          color: AppColor.customGrey),
                    );
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 20 + kBottomNavigationBarHeight,
            ),
            // SizedBox(height: 20,),
            CustomButton(
              isLoading: widget.isRecoverPassword
                  ? context.watch<RecoverPasswordProvider>().buttonLoader
                  : context.watch<RegistrationProvider>().buttonLoader,
              onPressed: widget.isRecoverPassword
                  ? () async {
                      var formData = FormData.fromMap({
                        "phone": widget.mobileNumber,
                        "otp": otpController.text
                      });
                      if (otpController.text.isNotEmpty &&
                          otpController.text.length == 6) {
                        var response = await recoverPassProvider
                            .recoverPasswordVerification(context, formData);
                        if(response['status_code'] == 200){
                          Navigator.pushNamedAndRemoveUntil(
                              arguments: {
                                "mobile" : widget.mobileNumber
                              },
                              context, AppScreen.changePassword, (route) => false);
                        }
                        if (response['status_code'] == 201) {
                          otpController.clear();
                        }
                      }
                    }
                  : () async {
                      var formData = FormData.fromMap(
                          {"phone": mobileNo, "otp": otpController.text});
                      print("request body ${formData.fields}");
                      if (otpController.text.isNotEmpty &&
                          otpController.text.length == 6) {
                        var response =
                            await provider.verifyOtp(context, formData);
                        if (response['status_code'] == 201) {
                          otpController.clear();
                        }
                      }
                    },
              width: AppSize.getWidth(context),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.lightYellow),
              buttonText: "Verify",
            ),

            const SizedBox(
              height: 25,
            ),

            Visibility(
              visible: context.watch<AuthProvider>().start == 0,
              child: const Text(
                "Didn't receive code ?",
                style: TextStyle(color: AppColor.customGrey),
              ),
            ),

            Visibility(
              visible: context.watch<AuthProvider>().start == 0,
              child: InkWell(
                onTap: () {
                  context.read<AuthProvider>().startTimer();
                  var formData = FormData.fromMap({"phone": mobileNo});
                  authProvider.sendOtp(context, formData);
                },
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                      color: AppColor.black,
                      fontFamily: AppFont.poppinsSemiBold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
