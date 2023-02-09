import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../API Integration/API URL endpoints/api_endpoints.dart';
import '../../API Integration/call_api.dart';
import '../../API Response Model/Support History ID Model/support_history_id_model.dart';
import '../../Component/custom_button.dart';
import '../../Component/custom_loader.dart';
import '../../Component/icon_card.dart';
import '../../Component/try_again.dart';
import '../../Providers/Support History ID Provider/support_history_id_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_size.dart';

class ChatScreen extends StatefulWidget {
  final String supportId;
  const ChatScreen({Key? key,required this.supportId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var messageController = TextEditingController();
  final appApi = AppApi();
  File? _image;
  XFile? imageFile;
  final picker = ImagePicker();

  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(listScrollController.hasClients){
      final position = listScrollController.position.maxScrollExtent;
      listScrollController.animateTo(
        position,
        duration: const Duration(seconds: 0),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose(){
    messageController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

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
      }
      else {
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
      }
      else {
        print("Camera access denied!.. $cameraStatus and $storageStatus");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupportHistoryIdProvider>(context, listen: false);
    print("support id is => ${widget.supportId}");
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  //  height: 50,
                  //  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.white
                  ),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          openGallery();
                        },
                        icon: Icon(Icons.attach_file,color: AppColor.grey1),
                      ),
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      hintText: "Message",
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: AppFont.poppinsSemiBold),
                      fillColor: AppColor.customWhite,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColor.lightYellow,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColor.lightYellow,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColor.lightYellow,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColor.lightYellow,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (messageController.text.isNotEmpty) {
                    var chatRequest = _image != null ? FormData.fromMap({
                      "support_id": widget.supportId,
                      "massage": messageController.text,
                      "image" : MultipartFile.fromFile(_image!.path.split('/').last)
                    }) : FormData.fromMap({
                      "support_id": widget.supportId,
                      "massage": messageController.text,
                    });
                    var response = await appApi.supportUserMessage(body: chatRequest);
                    if(response.statusCode == 200){
                      messageController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    }
                    print("chat request body ${chatRequest.fields}");
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: AppColor.lightYellow,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(child: SvgPicture.asset(AppImages.share)),
                ),
              )
            ],
          ),
        ),
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: iconCard(
              icon: SvgPicture.asset(AppImages.backIcon),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "Help",
            style: TextStyle(
                fontFamily: AppFont.poppinsMedium,
                fontSize: 14,
                color: AppColor.black),
          ),
        ),
        body: FutureBuilder(
            future: provider.supportDataId(context, widget.supportId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var chatData = snapshot.data as List<SupportHistoryIdModel>;
                  // print(
                  //     "Chat data response => ${chatData.support?.subject.toString()}");
                  return ListView(
                    controller: listScrollController,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //     margin: EdgeInsets.all(10),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 15, vertical: 12),
                      //     decoration: BoxDecoration(
                      //         color: AppColor.customWhite,
                      //         borderRadius: BorderRadius.circular(15)),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Flexible(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 "subject",
                      //                 style: TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 14,
                      //                     fontFamily: AppFont.poppinsSemiBold),
                      //               ),
                      //               Text(
                      //                 "created at",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 12,
                      //                 ),
                      //               ), //12th, Dec, 2022 | 09:00 AM"
                      //
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //
                      //               Text(
                      //                 "message",
                      //                 style: TextStyle(
                      //                   overflow: TextOverflow.ellipsis,
                      //                   color: Colors.grey,
                      //                   fontSize: 12,
                      //                   fontFamily: AppFont.poppinsSemiBold,
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             Text(
                      //               "chat data",
                      //               style: TextStyle(
                      //                   color: AppColor.green,
                      //                   fontSize: 14,
                      //                   fontFamily: AppFont.poppinsSemiBold),
                      //             ),
                      //
                      //             // Text("Resolve",style: TextStyle(
                      //             //     color: Colors.grey,
                      //             //     fontSize: 12,
                      //             //     fontFamily: AppFont.poppinsSemiBold
                      //             // ),)
                      //           ],
                      //         ),
                      //       ],
                      //     )),
                      Visibility(
                        visible: chatData.isNotEmpty,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            left: 8, right: 8,
                            bottom: kBottomNavigationBarHeight + 20,
                            // vertical: kBottomNavigationBarHeight + 20,
                          ),
                          itemCount: chatData.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return chatData[index].type == "robot" ? receiveMessagesCard(
                              context: context,
                              message: chatData[index].message ?? "",
                              profileImage: SvgPicture.asset(AppImages.robot),
                              time: chatData[index].createdAt ?? "",
                            ) : senderMessagesCard(
                              context: context,
                              time: chatData[index].createdAt ?? "",
                              message: chatData[index].message ?? "",
                              profileImage: Image.asset(AppImages.avatar)
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return tryAgain(
                      onTap: () => setState(() {}));
                }
              }
              return customLoader();
            })
    );
  }

  Widget senderMessagesCard({
    required String message,
    required BuildContext context,
    required Widget profileImage,
    required String time,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: AppSize.getWidth(context) / 2 ,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColor.customWhite,
                  borderRadius: BorderRadius.circular(11)),
              child: Text(message,
                  style: TextStyle(
                      color: AppColor.darkGrey,
                      fontFamily: AppFont.poppinsMedium,
                      fontSize: 13)),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 5),
              child: Text(time,
                  style: TextStyle(
                      color: AppColor.grey1,
                      fontFamily: AppFont.poppinsRegular,
                      fontSize: 13)),
            ),
            // Visibility(
            //   visible: _image != null,
            //   child: Container(
            //     clipBehavior: Clip.hardEdge,
            //     width: AppSize.getWidth(context) / 2,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15)
            //     ),
            //     child: Image.file(_image!,fit: BoxFit.cover)
            //   ),
            // )
          ],
        ),
        SizedBox(
          width: 5,
        ),
        // Container(
        //   height: 15,
        //   width: 15,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(5),
        //     child: profileImage,
        //   ),
        // ),
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 10, // Image radius
          child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: profileImage),
        ),
      ],
    );
  }

  Widget receiveMessagesCard({
    required String message,
    required BuildContext context,
    required Widget? profileImage,
    required String time,
    String? attachment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 5,
          ),
          // CircleAvatar(
          //   radius: 10, // Image radius
          //   backgroundImage: profileImage,
          // ),
          Container(
            height: 15,
            width: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: profileImage,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSize.getWidth(context) / 2,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: AppColor.customWhite,
                    borderRadius: BorderRadius.circular(11)),
                child: Text(message,
                    style: TextStyle(
                      color: AppColor.darkGrey,
                      fontFamily: AppFont.poppinsMedium,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, bottom: 10, top: 5),
                child: Text(time,
                    style: TextStyle(color: AppColor.grey1, fontSize: 13)),
              ),
              Visibility(
                visible: attachment != null && attachment != "",
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: AppSize.getWidth(context) / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: AppImages.loader,
                    image: Endpoints.imageUrl + attachment.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
