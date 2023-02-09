import 'package:dio/dio.dart';
import 'package:dp_boss/Providers/Registration%20Provider/registration_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';

class Registration extends StatefulWidget {

  const Registration({Key? key,}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState(){

    super.initState();
  }

  String? validatePass(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length < 6) {
      return "Should at least 6 characters";
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length < 10) {
      return "Invalid Mobile Number";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Required';
    if (value != passwordController.text) return 'Not Match';
    return null;
  }

  String? validation(String? value) {
    if (value!.isEmpty) {
      return "Required";
    }
    return null;
  }

  @override
  void dispose(){
    fullNameController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referCodeController.dispose();
    super.dispose();
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context,listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height + 40, bottom: 100),
                child: Image.asset(AppImages.logo),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Register",
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
                  "Register Now to get full access",
                  style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontFamily: AppFont.poppinsRegular),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              CustomTextField(
                validator: validation,
                hintText: "Full Name",
                controller: fullNameController,
              ),

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                validator: validation,
                hintText: "Enter Mobile Number",
                // onChanged: (val) {
                //   if (val.length == 10) {
                //     FocusScope.of(context).unfocus(); // disable keyboard
                //   }
                // },
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"\d"), // allow only numbers
                  )
                ],
                keyboardType: TextInputType.number,
                controller: mobileNumberController,
              ),

              SizedBox(
                height: 15,
              ),

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

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                obscureText: true,
                validator: validateConfirmPassword,
                controller: confirmPasswordController,
                hintText: "Confirm Password",
              ),

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                // obscureText: true,
                // validator: validateConfirmPassword,
                controller: referCodeController,
                hintText: "Refer Code",
              ),

              SizedBox(
                height: 50,
              ),
              // SizedBox(height: 20,),

              CustomButton(
                isLoading: context.watch<RegistrationProvider>().buttonLoader,
                onPressed: () async{
                  var isValidate = formKey.currentState?.validate();
                  var formData = FormData.fromMap({
                    "phone": mobileNumberController.text,
                    "name": fullNameController.text,
                    "password": passwordController.text,
                    "cpassword": confirmPasswordController.text,
                    "refer_code": referCodeController.text,
                  });
                  if(isValidate != null && isValidate == true){
                    if(mobileNumberController.text.isNotEmpty && fullNameController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
                      final response = await provider.registration(context, formData, mobileNumberController.text);
                      if(response['status_code'] == 204){
                        mobileNumberController.clear();
                        fullNameController.clear();
                        passwordController.clear();
                        confirmPasswordController.clear();
                        referCodeController.clear();
                      }
                    }
                  }
                },
                width: AppSize.getWidth(context),
                backgroundColor: MaterialStateProperty.all<Color>(AppColor.lightYellow),
                buttonText: "CREATE ACCOUNT",
              ),
              SizedBox(
                height: 15,
              ),
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
                          Navigator.pop(context);
                        }
                    )
                  ]
              )),
              SizedBox(
                height: 15,
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
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
