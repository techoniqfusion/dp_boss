import 'package:dio/dio.dart';
import 'package:dp_boss/Component/textheading.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../Component/icon_card.dart';
import '../../Component/pop_up.dart';
import '../../Providers/Add Bank Details Provider/add_bank_details_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({Key? key}) : super(key: key);

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  final formKey = GlobalKey<FormState>();
  bool isShowOverlayLoader = false;
  var accHolderNameController = TextEditingController();
  var accountNumberController = TextEditingController();
  var ifscController = TextEditingController();
  var branchController = TextEditingController();
  var bankNameController = TextEditingController();

  @override
  void dispose() {
    accHolderNameController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AddBankDetailsProvider>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: CustomButton(
              // width: AppSize.getWidth(context),
              isLoading: context.watch<AddBankDetailsProvider>().isShowLoader,
              onPressed: () async {
                var formValidate = formKey.currentState?.validate();
                if (formValidate == true) {
                  var formData = FormData.fromMap({
                    "account_number": accountNumberController.text,
                    "account_ifsc_code": ifscController.text,
                    "account_holder_name": accHolderNameController.text
                  });
                  print("add bank account form data ${formData.fields}");
                  var response =
                      await provider.addBankDetails(context, formData);
                  if (response["status"] == 200) {
                    popUp(
                      context: context, title: response['message'],
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, AppScreen.dashboard);
                          },
                          child: const Text("okay"),
                        ),
                      ],
                    );
                    // accHolderNameController.clear();
                    // accountNumberController.clear();
                    // ifscController.clear();
                    // branchController.clear();
                    // bankNameController.clear();
                  }
                }
              },
              buttonText: "Continue",
              backgroundColor:
                  const MaterialStatePropertyAll<Color>(AppColor.lightYellow),
            ),
          ),
          appBar: AppBar(
            elevation: 1,
            title: const Text(
              "Add Bank Account",
              style: TextStyle(
                  fontFamily: AppFont.poppinsMedium,
                  fontSize: 14,
                  color: AppColor.black),
            ),
            backgroundColor: Colors.white,
            leading: iconCard(
                icon: SvgPicture.asset(AppImages.backIcon),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppScreen.dashboard)
                      .then((value) => setState(() {}));
                }),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              children: [
                textHeading(text: "Account Holder Name"),
                CustomTextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
                  ],
                  validator: Validation.validate,
                  controller: accHolderNameController,
                  horizontalContentPadding: 30,
                  hintText: "Account Holder Name",
                  padding: EdgeInsets.only(bottom: 25),
                ),

                textHeading(text: "Account Number"),

                /// Account Number TextField
                CustomTextField(
                  // obscureText: true,
                  validator: Validation.validate,
                  maxLength: 18,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[0-9]"),
                    )
                  ],
                  controller: accountNumberController,
                  horizontalContentPadding: 30,
                  hintText: "ACCOUNT NUMBER",
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.only(bottom: 25),
                ),
                textHeading(text: "IFSC Code"),
                CustomTextField(
                  textCapitalization: TextCapitalization.characters,
                  validator: Validation.validateIfsc,
                  controller: ifscController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    )
                  ],
                  hintText: "IFSC CODE",
                  maxLength: 11,
                  onChanged: (val) async {
                    if (val.length == 11) {
                      setState(() {
                        isShowOverlayLoader = true;
                      });
                      try {
                        FocusScope.of(context).unfocus();
                        final response = await Dio().get(
                            "https://ifsc.razorpay.com/${ifscController.text}");
                        print("response data is $response");
                        if (response.statusCode == 200) {
                          setState(() {
                            isShowOverlayLoader = false;
                          });
                          bankNameController.text = response.data['BANK'];
                          branchController.text = response.data['BRANCH'];
                          ifscController.value = TextEditingValue(
                              text: val.toUpperCase(),
                              selection: ifscController.selection);
                        }
                      } catch (error) {
                        setState(() {
                          isShowOverlayLoader = false;
                        });
                        // print("error message is ${error}");
                        // throw errorMessage;
                      }
                    } else {
                      bankNameController.clear();
                      branchController.clear();
                    }
                  },
                  padding: EdgeInsets.only(bottom: 25),
                  horizontalContentPadding: 30,
                ),

                textHeading(text: "Branch"),

                /// Branch TextField
                CustomTextField(
                  controller: branchController,
                  readOnly: true,
                  hintText: "Branch",
                  padding: EdgeInsets.only(bottom: 25),
                  horizontalContentPadding: 30,
                ),

                textHeading(text: "Bank Name"),

                /// Bank Name TextField
                CustomTextField(
                  validator: Validation.validate,
                  controller: bankNameController,
                  horizontalContentPadding: 30,
                  hintText: "Enter Bank Name",
                  readOnly: true,
                  padding: EdgeInsets.only(bottom: 25),
                ),
              ],
            ),
          ),
        ),
        if (isShowOverlayLoader)
          Container(
            color: Colors.white70,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColor.black,
            ),
          )
      ],
    );
  }
}
