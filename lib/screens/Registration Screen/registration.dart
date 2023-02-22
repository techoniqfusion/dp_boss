import 'package:dio/dio.dart';
import 'package:dp_boss/Providers/Registration%20Provider/registration_provider.dart';
import 'package:dp_boss/utils/open_whatsApp.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Support Details Model/support_details_model.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../Component/pop_up.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';

class Registration extends StatefulWidget {
  const Registration({
    Key? key,
  }) : super(key: key);

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
  String referedBy = "";
  bool referCodeStatus = false;
  bool isReadOnly = false;
  final appApi = AppApi();
  var supportDetails;

  @override
  void initState() {
    super.initState();
    getSupportDetails().then((value) {
      // setState(() {
      supportDetails = value;
      // });
    });
  }

  Future getSupportDetails() async {
    final response = await appApi.supportDetailsApi();
    if (response.data['status'] == true) {
      final responseData = SupportModel.fromJson(response.data['support_data']);
      // print("user whatsApp number ${responseData.whatsapp}");
      return responseData;
    }
  }

  /// validation for confirm password
  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Required';
    if (value != passwordController.text) return 'Not Match';
    return null;
  }

  /// dispose all controllers
  @override
  void dispose() {
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
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
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
                    top: AppBar().preferredSize.height + 40, bottom: 50),
                child: Image.asset(AppImages.logo, height: 200),
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
                validator: Validation.validate,
                hintText: "Full Name",
                controller: fullNameController,
              ),

              SizedBox(
                height: 15,
              ),

              CustomTextField(
                validator: Validation.validateMobile,
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
                  validator: Validation.validatePass,
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

              // SizedBox(
              //   height: 15,
              // ),

              StatefulBuilder(builder: (context, setTextField) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      controller: referCodeController,
                      hintText: "Refer Code",
                      maxLength: 6,
                      readOnly: isReadOnly,
                      suffixIcon: referCodeController.text.length == 6
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColor.darkGrey,
                              ),
                              onPressed: () {
                                referCodeController.clear();
                                setTextField(() {
                                  referedBy = "";
                                  isReadOnly = false;
                                });
                              },
                            )
                          : SizedBox.shrink(),
                      onChanged: (value) async {
                        if (value.length == 6) {
                          referCodeController.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: referCodeController.selection);
                          FocusScope.of(context).unfocus();
                          try {
                            final response = await appApi
                                .referCheckApi(referCodeController.text);
                            // dioClient.post(
                            //     "${Endpoints.baseUrl}after-login/user-first-time/refer-check",
                            //     data: formData);
                            print("response of refer code api is ${response}");
                            if (response.data['status'] == true) {
                              setTextField(() {
                                referedBy = response.data['name'];
                                referCodeStatus = true;
                                isReadOnly = true;
                              });
                            } else {
                              setTextField(() {
                                referCodeStatus = false;
                                isReadOnly = true;
                              });
                              popUp(
                                  context: context,
                                  title: response.data['message'],
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("okay"))
                                  ]);
                            }
                          } catch (error) {}
                        }
                      },
                      // suffixIcon: IconButton(
                      //   onPressed: () => _selectDate(context),
                      //   icon: Icon(Icons.calendar_today,color: Colors.black,),
                      // ),
                    ),
                    Visibility(
                      visible: referedBy.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          "Referred by ${referedBy}",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    )
                  ],
                );
              }),

              SizedBox(
                height: 50,
              ),
              // SizedBox(height: 20,),
              CustomButton(
                isLoading: context.watch<RegistrationProvider>().buttonLoader,
                onPressed: () async {
                  var isValidate = formKey.currentState?.validate();
                  var formData = FormData.fromMap({
                    "phone": mobileNumberController.text,
                    "name": fullNameController.text,
                    "password": passwordController.text,
                    "cpassword": confirmPasswordController.text,
                    "refer_code": referCodeController.text,
                  });
                  if (isValidate != null && isValidate == true) {
                    if (mobileNumberController.text.isNotEmpty &&
                        fullNameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        confirmPasswordController.text.isNotEmpty) {
                      final response = await provider.registration(
                          context, formData, mobileNumberController.text);
                      if (response['status_code'] == 204) {
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
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.lightYellow),
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
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          })
                  ])),

              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        print("whatsApp number ${supportDetails.whatsapp}");
                        OpenSocialMediaApp.openWhatsApp(
                            mobileNumber: supportDetails.whatsapp ?? "",
                            context: context);
                      },
                      child: SvgPicture.asset(
                        AppImages.whatsApp_icon,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      AppImages.telegramIcon,
                    ),
                    onTap: () async {
                      Uri phoneNumber = Uri.parse(supportDetails.telegram);
                      await launchUrl(phoneNumber);
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      print("phone number ${supportDetails.callOne}");
                      Uri phoneNumber = Uri.parse('tel:${supportDetails.callOne}');
                      await launchUrl(phoneNumber);
                    },
                    icon: Icon(Icons.call, size: 35),
                  ),
                ],
              ),

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
                        recognizer: TapGestureRecognizer()..onTap = () {})
                  ])),

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
