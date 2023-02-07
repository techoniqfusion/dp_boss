import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Component/custom_button.dart';
import '../../Component/icon_card.dart';
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
  bool isCompleted = false; //check completeness of inputs
  final formKey =
      GlobalKey<FormState>(); //form object to be used for form validation

  File? panFrontImg;
  XFile? panFrontImgFile;
  File? panBackImg;
  XFile? panBackImgFile;
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
            source: ImageSource.camera, imageQuality: 20);
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
        } else if (key == "pan_back") {
          panBackImgFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 20);
          if (panBackImgFile != null) {
            setState(() {
              panBackImg = File(panBackImgFile!.path);
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
          if (aadhaarFrontImgFile != null) {
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

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: formKey,
        child: Stepper(
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
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              print("complete");
            }
            // else if (aadhaarFrontImg == null &&
            //     aadhaarBackImg == null &&
            //     aadhaarNoController.text.isEmpty) {
            //   popUp(context: context, title: "Fill All Fields", actions: [
            //     TextButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         child: Text("okay"))
            //   ]);
            // }
            else {
              setState(() {
                currentStep += 1;
              });
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
      ),
    );
  }

  Widget controlBuilder(context, details) {
    final isLastStep = currentStep == getSteps().length - 1;
    return Row(
      children: [
        Visibility(
          visible: !isLastStep,
          child: CustomButton(
            height: 18,
            onPressed: details.onStepContinue,
            buttonText: "Continue",
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.lightYellow),
          ),
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
              CustomTextField(
                keyboardType: TextInputType.multiline,
                hintText: "Enter Aadhaar Card Number",
                hintStyle: TextStyle(color: Colors.grey),
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
                CustomTextField(
                  keyboardType: TextInputType.multiline,
                  hintText: "Enter PAN Card Number",
                  hintStyle: TextStyle(color: Colors.grey),
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
                ),
                panBackImg != null
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
                              panBackImg!,
                              // File(image?.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  panBackImg = null;
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
                          openGallery(key: "pan_back");
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
                                    "Upload Pan Card Back Side",
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
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
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
