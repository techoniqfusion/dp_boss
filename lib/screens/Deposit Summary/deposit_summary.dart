import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/pop_up.dart';
import 'package:dp_boss/Component/textheading.dart';
import 'package:dp_boss/Providers/Deposit%20Summary%20Provider/deposit_summary_provider.dart';
import 'package:dp_boss/utils/show_toast.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/app_size.dart';

class DepositSummary extends StatefulWidget {
  final String? upiId;
  final String? amount;
  const DepositSummary({Key? key, this.upiId, this.amount}) : super(key: key);

  @override
  State<DepositSummary> createState() => _DepositSummaryState();
}

class _DepositSummaryState extends State<DepositSummary> {
  var utrNumberController = TextEditingController();
  File? _image;
  XFile? imageFile;
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  openGallery() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    PermissionStatus? cameraShowAlert;
    PermissionStatus? storageShowAlert;
    if (!cameraStatus.isGranted) {
      cameraShowAlert = await Permission.camera.request();
    }
    if (!storageStatus.isGranted) {
      storageShowAlert = await Permission.storage.request();
    }
    if (await Permission.camera.isGranted) {
      if (await Permission.storage.isGranted) {
        imageFile = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 20);
        if (imageFile != null) {
          setState(() {
            _image = File(imageFile!.path);
          });
        }
      } else {
        print("Camera needs to access your storage, please provide permission");
      }
    } else {
      if (cameraShowAlert == PermissionStatus.permanentlyDenied ||
          storageShowAlert == PermissionStatus.permanentlyDenied) {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Requires Camera Permission'),
                content: const Text(
                    'This application requires access to your camera and storage'),
                actions: <Widget>[
                  CustomButton(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.lightYellow),
                    textColor: AppColor.white,
                    buttonText: 'Allow',
                    onPressed: () async {
                      await openAppSettings();
                      Navigator.pop(context);
                    },
                  ),
                  CustomButton(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.lightYellow),
                    textColor: AppColor.white,
                    buttonText: 'Cancel',
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      } else {
        print("Camera access denied!.. $cameraStatus and $storageStatus");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<DepositSummaryProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: CustomButton(
          isLoading: context.watch<DepositSummaryProvider>().isShowLoader,
          backgroundColor: MaterialStatePropertyAll(AppColor.lightYellow),
          buttonText: "Proceed to Pay",
          onPressed: () async {
            var isValidate = formKey.currentState?.validate();
            if (isValidate != null && isValidate == true) {
              if (_image == null) {
                popUp(context: context, title: "Upload Screenshot", actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("okay"),
                  ),
                ]);
              } else {
                if (isValidate && _image != null) {
                  String? fileName;
                  fileName = _image?.path.split('/').last;
                  print("file name $fileName");
                  print("file  $_image");
                  var imgData = await MultipartFile.fromFile(_image!.path, filename: fileName);
                  print("formdata image => ${imgData.filename}");
                  print("formdata amount => ${widget.amount}");
                  print("formdata utr_no => ${utrNumberController.text}");
                  print("formdata upi_id => ${widget.upiId}");
                  var formData = FormData.fromMap({
                    "image": imgData,
                    "amount": widget.amount,
                    "utr_no": utrNumberController.text,
                    "upi_id": widget.upiId
                  });
                  final response =
                      await provider.manualDepositAmount(context, formData);
                  if (response['status_code'] == 200) {
                    popUp(context: context, title: response['message'], actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, AppScreen.walletScreen,(route) => false,);
                        },
                        child: const Text("okay"),
                      ),
                    ]);
                  }
                }
              }
            }
          },
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          "Summary of Deposit",
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
          Row(
            children: [
              textHeading(text: "Amount:"),
              textHeading(text: "${widget.amount}"),
              Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.amount));
                  showToast("Copied to clipboard");
                },
                child: Text(
                  "copy",
                  style: TextStyle(color: AppColor.yellow),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              textHeading(text: "UPI ID:"),
              textHeading(text: "${widget.upiId}"),
              Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.upiId));
                  showToast("Copied to clipboard");
                },
                child: Text(
                  "copy",
                  style: TextStyle(color: AppColor.yellow),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          textHeading(text: "UTR Number"),
          Form(
            key: formKey,
            child: CustomTextField(
              controller: utrNumberController,
              hintText: "Enter UTR Number",
              validator: Validation.validate,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"\d"), // allow only numbers
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          textHeading(text: "Upload transaction screenshot"),
          SizedBox(
            height: 20,
          ),
           _image != null
                ? Stack(
                    children: [
                      Container(
                        height: 100,
                        width: AppSize.getWidth(context),
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Image.file(
                          _image!,
                          // fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              _image = null;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.clear,
                              color: AppColor.black,
                            )),
                      )
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      openGallery();
                    },
                    child: DottedBorder(
                      dashPattern: [7, 5],
                      //borderPadding: EdgeInsets.symmetric(horizontal: 10),
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      //padding: EdgeInsets.all(6),
                      child: Container(
                          height: 100,
                          width: AppSize.getWidth(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: AppColor.customWhite,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                    child: Text(
                                  "+",
                                  style: TextStyle(color: Colors.black),
                                )),
                              ),
                              Text(
                                "Choose File (JPG/PNG)",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  )
        ],
      ),
    );
  }
}
