import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/icon_card.dart';
import '../../Component/pop_up.dart';
import '../../Providers/Verificartion Provider/verification_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  int currentStep = 0;
  var aadhaarNoController = TextEditingController();
  var panNoController = TextEditingController();
  bool isCompleted = false; //check completeness of inputs

  final formKey =
      GlobalKey<FormState>(); //form object to be used for form validation
  final form2Key = GlobalKey<FormState>();

  File? panFrontImg;
  XFile? panFrontImgFile;
  File? aadhaarFrontImg;
  XFile? aadhaarFrontImgFile;
  File? aadhaarBackImg;
  XFile? aadhaarBackImgFile;
  File? selfieImg;
  XFile? selfieImgFile;

  final picker = ImagePicker();

  openCamera() async {
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
        selfieImgFile = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 20,
            preferredCameraDevice: CameraDevice.front);
        if (selfieImgFile != null) {
          setState(() {
            selfieImg = File(selfieImgFile!.path);
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
            builder: (context) {
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
        print("Provide Camera permission to use camera.");
      }
    }
  }

  openGallery({String? key}) async {
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
        if (key == "pan_front") {
          panFrontImgFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 20);
          if (panFrontImgFile != null) {
            setState(() {
              panFrontImg = File(panFrontImgFile!.path);
            });
          }
        } else if (key == "aadhar_front") {
          aadhaarFrontImgFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 20);
          if (aadhaarFrontImgFile != null) {
            setState(() {
              aadhaarFrontImg = File(aadhaarFrontImgFile!.path);
            });
          }
        } else if (key == "aadhar_back") {
          aadhaarBackImgFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 20);
          if (aadhaarBackImgFile != null) {
            setState(() {
              aadhaarBackImg = File(aadhaarBackImgFile!.path);
            });
          }
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
                    buttonText: 'Allow',
                    onPressed: () async {
                      await openAppSettings();
                      Navigator.pop(context);
                    },
                  ),
                  CustomButton(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.lightYellow),
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

  String? validatePan(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (!RegExp("^([A-Z]){5}([0-9]){4}([A-Z]){1}?\$").hasMatch(value)) {
      return "Invalid PAN Number";
    }
    return null;
  }

  String? validateAadhaar(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length != 12) return "Invalid Aadhaar Number";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerificationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          "Verify",
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
            }),
      ),
      body: Stepper(
        elevation: 0,
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: currentStep,
        // onStepTapped: (step) {
        //   formKey.currentState!.validate(); //this will trigger validation
        //   setState(() {
        //     currentStep = step;
        //   });
        // },
        onStepContinue: () async {
          var isValidate = currentStep == 0
              ? formKey.currentState?.validate()
              : form2Key.currentState?.validate();
          print("current step value $currentStep");
          final isLastStep = currentStep == getSteps().length - 1;
          if (isLastStep) {
            print("complete");
            if (selfieImg == null) {
              popUp(context: context, title: "Fill All Fields", actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("okay"))
              ]);
            } else {
              String? aadhaarFrontFileName;
              String? aadhaarBackFileName;
              String? panCardFileName;
              String? selfieFileName;
              if (aadhaarFrontImg != null &&
                  aadhaarBackImg != null &&
                  panFrontImg != null &&
                  selfieImg != null) {
                aadhaarFrontFileName = aadhaarFrontImg?.path.split('/').last;
                aadhaarBackFileName = aadhaarBackImg?.path.split('/').last;
                panCardFileName = panFrontImg?.path.split('/').last;
                selfieFileName = selfieImg?.path.split('/').last;
                var formData = FormData.fromMap({
                  "aadhar_card_number": aadhaarNoController.text,
                  "aadhar_card_front": await MultipartFile.fromFile(
                      aadhaarFrontImg!.path,
                      filename: aadhaarFrontFileName),
                  "aadhar_card_back": await MultipartFile.fromFile(
                      aadhaarBackImg!.path,
                      filename: aadhaarBackFileName),
                  "pan_card_number": panNoController.text,
                  "pan_card_front": await MultipartFile.fromFile(
                      panFrontImg!.path,
                      filename: panCardFileName),
                  "user_selfie": await MultipartFile.fromFile(selfieImg!.path,
                      filename: selfieFileName)
                });
                final response = await provider.verification(context, formData);
                if (response.data['status'] == 200) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                        title: Text(
                          response.data['mess'],
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("okay"),
                          ),
                        ]),
                  );
                  setState(() {});
                }
              }
            }
          } else if (currentStep == 0 &&
                  (aadhaarFrontImg == null ||
                      aadhaarBackImg == null ||
                      aadhaarNoController.text.isEmpty) ||
              currentStep == 1 &&
                  (panFrontImg == null || panNoController.text.isEmpty)) {
            popUp(context: context, title: "Fill All Fields", actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("okay"))
            ]);
          } else if (isValidate != null && !isValidate && currentStep == 0) {
            popUp(context: context, title: "Invalid Aadhaar Number", actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("okay"))
            ]);
          } else if (isValidate != null && !isValidate && currentStep == 1) {
            popUp(context: context, title: "Invalid PAN Number", actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("okay"))
            ]);
          } else {
            print("is last step $isLastStep");
            setState(() {
              currentStep += 1;
            });
            print("after on tap ${currentStep}");
          }
        },
        onStepCancel: currentStep == 0
            ? null
            : () {
                setState(() {
                  currentStep -= 1;
                });
              },
        controlsBuilder: controlBuilder,
      ),
    );
  }

  Widget controlBuilder(BuildContext context, details) {
    // final isLastStep = currentStep == getSteps().length - 1;
    return Row(
      children: [
        CustomButton(
          isLoading: context.watch<VerificationProvider>().buttonLoader,
          height: 18,
          onPressed: details.onStepContinue,
          buttonText: "Continue",
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.lightYellow),
        ),
        SizedBox(
          width: 10,
        ),
        Visibility(
          visible: currentStep != 0,
          child: CustomButton(
            height: 18,
            onPressed: details.onStepCancel,
            buttonText: "Back",
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.lightYellow),
          ),
        ),
      ],
    );
  }

  //This will be your screens
  List<Step> getSteps() => [
        Step(
          title: const Text('Aadhaar Card'),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          content: Column(
            children: [
              Form(
                key: formKey,
                child: CustomTextField(
                  controller: aadhaarNoController,
                  validator: validateAadhaar,
                  maxLength: 12,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"\d"), // allow only numbers
                    )
                  ],
                  keyboardType: TextInputType.number,
                  hintText: "Enter Aadhaar Card Number",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              aadhaarFrontImg != null
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
                            aadhaarFrontImg!,
                            // File(image?.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                aadhaarFrontImg = null;
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
                        openGallery(key: "aadhar_front");
                      },
                      child: DottedBorder(
                        //borderPadding: EdgeInsets.symmetric(horizontal: 10),
                        borderType: BorderType.RRect,
                        dashPattern: [7, 5, 0, 0],
                        radius: const Radius.circular(12),
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
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "+",
                                    style: TextStyle(color: Colors.black),
                                  )),
                                ),
                                Text(
                                  "Upload Aadhaar Card Front Side",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              aadhaarBackImg != null
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
                            aadhaarBackImg!,
                            // File(image?.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                aadhaarBackImg = null;
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
                        openGallery(key: "aadhar_back");
                      },
                      child: DottedBorder(
                        //borderPadding: EdgeInsets.symmetric(horizontal: 10),
                        borderType: BorderType.RRect,
                        dashPattern: [7, 5, 0, 0],
                        radius: const Radius.circular(12),
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
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "+",
                                    style: TextStyle(color: Colors.black),
                                  )),
                                ),
                                Text(
                                  "Upload Aadhaar Card Back Side",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Step(
            title: const Text('PAN Card'),
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            content: Column(
              children: [
                Form(
                  key: form2Key,
                  child: CustomTextField(
                    controller: panNoController,
                    validator: validatePan,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]"))
                    ],
                    // keyboardType: TextInputType.streetAddress,
                    hintText: "Enter PAN Card Number",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                panFrontImg != null
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
                              panFrontImg!,
                              // File(image?.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  panFrontImg = null;
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
                          openGallery(key: "pan_front");
                        },
                        child: DottedBorder(
                          //borderPadding: EdgeInsets.symmetric(horizontal: 10),
                          borderType: BorderType.RRect,
                          dashPattern: [7, 5, 0, 0],
                          radius: const Radius.circular(12),
                          //padding: EdgeInsets.all(6),
                          child: Container(
                              height: 100,
                              width: AppSize.getWidth(context),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "+",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                  ),
                                  Text(
                                    "Upload Pan Card Front Side",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              )),
                        ),
                      ),
                SizedBox(
                  height: 20,
                )
              ],
            )),
        Step(
            title: const Text("User Selfie"),
            state: selfieImg != null && currentStep >= 2
                ? StepState.complete
                : StepState.indexed,
            isActive: currentStep >= 2,
            content: Column(
              children: [
                selfieImg != null
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
                              selfieImg!,
                              // File(image?.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  selfieImg = null;
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
                          openCamera();
                        },
                        child: DottedBorder(
                          //borderPadding: EdgeInsets.symmetric(horizontal: 10),
                          borderType: BorderType.RRect,
                          dashPattern: [7, 5, 0, 0],
                          radius: const Radius.circular(12),
                          //padding: EdgeInsets.all(6),
                          child: Container(
                              height: 100,
                              width: AppSize.getWidth(context),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "+",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                  ),
                                  const Text(
                                    "Upload Selfie",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              )),
                        ),
                      ),
                SizedBox(
                  height: 20,
                )
              ],
            )),
      ];
}
