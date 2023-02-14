import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_textfield.dart';
import '../../Component/icon_card.dart';
import '../../Component/pop_up.dart';
import '../../Providers/Support Create Request Provider/support_create_request_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/app_size.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({Key? key}) : super(key: key);

  @override
  State<CreateRequest> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  int? fileSize;
  File? _image;
  XFile? imageFile;
  ImagePicker picker = ImagePicker();
  var subjectController = TextEditingController();
  var messageController = TextEditingController();

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
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<SupportCreateRequestProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, AppScreen.helpAndSupport);
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: CustomButton(
            isLoading:
                context.watch<SupportCreateRequestProvider>().isShowLoader,
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.lightYellow),
            buttonText: "Create Request",
            textColor: Colors.black,
            onPressed: () async {
              // print("Button pressed");
              if (subjectController.text.isNotEmpty &&
                  messageController.text.isNotEmpty) {
                String? fileName;
                FormData formData;
                if (_image != null) {
                  fileName = _image?.path.split('/').last;
                  formData = FormData.fromMap({
                    "subject": subjectController.text,
                    "massage": messageController.text,
                    "image": await MultipartFile.fromFile(_image!.path,
                        filename: fileName),
                  });
                  // print("file name ${fileName}");
                  // print("with image ${formData.fields.toString()}");
                 final response = await provider.supportCreateRequest(context, formData);
                 if(response["status"]){
                   subjectController.clear();
                   messageController.clear();
                   _image = null;
                   popUp(context: context, title: response['message'], actions: [
                     TextButton(
                       onPressed: () {
                         Navigator.popAndPushNamed(context, AppScreen.helpAndSupport);
                       },
                       child: const Text("okay"),
                     ),
                   ]);
                 }
                } else {
                  popUp(
                      context: context,
                      title: "Please Upload Image",
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("okay"),
                        ),
                      ]);
                }
              } else {
                popUp(
                    context: context,
                    title: "Enter All Required Filed",
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("okay"),
                      ),
                    ]);
              }
            },
          ),
        ),
        backgroundColor: AppColor.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: iconCard(
              icon: SvgPicture.asset(AppImages.backIcon),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppScreen.helpAndSupport);
              }),
          title: Text(
            "Help & Support",
            style: TextStyle(
                fontFamily: AppFont.poppinsMedium,
                fontSize: 14,
                color: AppColor.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: ListView(
            children: [
              Text(
                "You had a query with us",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: AppFont.poppinsSemiBold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "View Order Details >",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: subjectController,
                verticalContentPadding: 15,
                hintText: "Leave your Subject here ...",
                fillColor: AppColor.customWhite,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.multiline,
                controller: messageController,
                maxLines: 10,
                verticalContentPadding: 15,
                hintText: "Leave your Message here ...",
                fillColor: AppColor.customWhite,
                hintStyle: TextStyle(color: Colors.grey),
              ),
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
                            // File(image?.path),
                            fit: BoxFit.cover,
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
                                  "Choose File (JPG/PNG/PDF)",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
