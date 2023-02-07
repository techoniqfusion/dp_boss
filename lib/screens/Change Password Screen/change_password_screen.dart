import 'package:dio/dio.dart';
import 'package:dp_boss/Providers/Recover%20Password%20Provider/recover_password_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/app_size.dart';

class ChangePassword extends StatefulWidget {
  final String? mobileNumber;
  const ChangePassword({Key? key, this.mobileNumber}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isObscure = true;

  String? validatePass(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length < 6) {
      return "Should at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Required';
    if (value != passwordController.text) return 'Not Match';
    return null;
  }

  @override
  void dispose() {
    /// Dispose all controllers
    confirmPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("change password number ${widget.mobileNumber}");
    final provider = Provider.of<RecoverPasswordProvider>(context,listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              isLoading: context.watch<RecoverPasswordProvider>().buttonLoader,
              onPressed: () async{
                var formData = FormData.fromMap({
                  "phone" : widget.mobileNumber,
                  "password" : passwordController.text,
                  "cpassword" : confirmPasswordController.text
                });
                 var isValidate = formKey.currentState?.validate();
                 if(isValidate != null && isValidate == true) {
                  await provider.recoverPasswordStore(context, formData);
                }
              },
              width: AppSize.getWidth(context),
              backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
              buttonText: "Change Password",
            ),
            const SizedBox(height: 20,),
            Text.rich(TextSpan(
                text: "Already have an account ? ",
                style: TextStyle(
                    color: AppColor.customGrey,
                    fontSize: 14,
                    fontFamily: AppFont.poppinsMedium),
                children: [
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 14,
                          fontFamily: AppFont.poppinsSemiBold),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.pushNamedAndRemoveUntil(context, AppScreen.login, (route) => false);
                      }
                  )
                ]
            )),
            SizedBox(
              height: 5,
            ),
            Text.rich(TextSpan(
                text: "By continuing you agree to the ",
                style: TextStyle(
                    color: AppColor.customGrey,
                    fontSize: 14,
                    fontFamily: AppFont.poppinsMedium),
                children: [
                  TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                          color: AppColor.yellow,
                          fontSize: 14,
                          fontFamily: AppFont.poppinsSemiBold),
                      recognizer: TapGestureRecognizer()..onTap = (){}
                  )
                ]
            )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppBar().preferredSize.height + 40, bottom: 100
                ),
                child: Image.asset(AppImages.logo),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 20,
                      fontFamily: AppFont.poppinsSemiBold),
                ),
              ),
              SizedBox(height: 2,),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter new password",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontFamily: AppFont.poppinsRegular),
                ),
              ),
              SizedBox(height: 25,),
              StatefulBuilder(builder: (context, setTextField) {
                return CustomTextField(
                  obscureText: _isObscure,
                  fillColor: AppColor.white,
                  hintText: "Enter Password",
                  validator: validatePass,
                  controller: passwordController,
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.black,
                          size: 14),
                      onPressed: () {
                        setTextField(() {
                          _isObscure = !_isObscure;
                        });
                      }),
                );
              }),
              SizedBox(height: 15,),
              StatefulBuilder(builder: (context, setTextField) {
                return CustomTextField(
                  obscureText: _isObscure,
                  fillColor: AppColor.white,
                  hintText: "Confirm Password",
                  validator: validateConfirmPassword,
                  controller: confirmPasswordController,
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.black,
                          size: 14),
                      onPressed: () {
                        setTextField(() {
                          _isObscure = !_isObscure;
                        });
                      }),
                );
              }),
              // SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
