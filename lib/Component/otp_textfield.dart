import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../utils/app_color.dart';

class OtpTextField extends StatelessWidget {

  var otpController = TextEditingController();
  void Function(String)? onCompleted;

  OtpTextField({Key? key,required this.otpController,this.onCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      // obscureText: true,
      // obscuringCharacter: '*',
      // obscuringWidget: const FlutterLogo(
      //   size: 24,
      // ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r"\d"),
        )
      ],
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        activeColor: AppColor.white,
        selectedColor: AppColor.grey1,
        inactiveFillColor: AppColor.white,
        disabledColor: AppColor.white,
        selectedFillColor: AppColor.white,
        shape: PinCodeFieldShape.box,
        errorBorderColor: AppColor.white,
        inactiveColor: AppColor.grey1,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 53,
        fieldWidth: 50,
        activeFillColor: Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      // errorAnimationController: errorController,
      controller: otpController,
      keyboardType: TextInputType.number,
      // boxShadows: const [
      //   BoxShadow(
      //     offset: Offset(0, 1),
      //     color: Colors.black12,
      //     blurRadius: 10,
      //   )
      // ],
      onCompleted: onCompleted,
      //     (val) async {
      //   // print("OTP ${val}");
      //   // if (otpController.text.isNotEmpty) {
      //   //   var data =
      //   //   await authProvider.verifyOTP(context, formData);
      //   //   print("response data value is ${data['message']}");
      //   //   if (!data['status'] && data['status_code'] == 201) {
      //   //     otpController.clear();
      //   //   }
      //   // }
      // },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {},
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}
