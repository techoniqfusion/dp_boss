import 'package:dio/dio.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Component/icon_card.dart';
import '../../Component/pop_up.dart';
import '../../Providers/Add Upi Provider/add_upi_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class AddUPI extends StatefulWidget {
  final String? upiType;
  final String? upiId;
  const AddUPI({Key? key, this.upiType, this.upiId}) : super(key: key);

  @override
  State<AddUPI> createState() => _AddUPIState();
}

class _AddUPIState extends State<AddUPI> {
  var upiIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    if(widget.upiId != null){
      upiIdController.text = widget.upiId!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    upiIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddUpiProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: CustomButton(
          isLoading: context.watch<AddUpiProvider>().buttonLoader,
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.lightYellow),
          buttonText: "Submit",
          onPressed: () async {
            var formValidate = formKey.currentState?.validate();
            if (formValidate == true) {
              var formData = FormData.fromMap({
                "name": widget.upiType == "Paytm"
                    ? "paytm"
                    : widget.upiType == "Google Pay"
                        ? "gpay"
                        : widget.upiType == "PhonePay"
                            ? "phonepe"
                            : "upi_id",
                "id": upiIdController.text
              });
              print("form data ${formData.fields}");
              final response = await provider.addUpi(context, formData);
              if (response['status_code'] == 200) {
                popUp(
                  context: context,
                  title: "${response['message']}", // show popUp
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppScreen.dashboard);
                      },
                      child: const Text("okay"),
                    ),
                  ],
                );
              }
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
              // Navigator.pushReplacementNamed(context, AppScreen.dashboard)
              //     .then((value) {
              //   setState(() {});
              // });
            }),
        title: Text(
          widget.upiType ?? "",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(
            height: 20,
          ),
          widget.upiType == "Paytm"
              ? Image.asset(
                  AppImages.paytm,
                  height: 39,
                )
              : widget.upiType == "Google Pay"
                  ? Image.asset(
                      AppImages.googlePay,
                      height: 50,
                    )
                  : widget.upiType == "PhonePay"
                      ? Image.asset(
                          AppImages.phonePe,
                          height: 50,
                        )
                      : Image.asset(
                          AppImages.whatsApp,
                          height: 50,
                        ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Add/Update your ${widget.upiType} Mobile Number",
            style: TextStyle(color: AppColor.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Form(
            key: formKey,
            child: CustomTextField(
              hintText: "Enter Your Mobile Number",
              controller: upiIdController,
              validator: Validation.validateMobile,
            ),
          )
        ],
      ),
    );
  }
}
