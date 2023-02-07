import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Providers/Auth%20Provider/auth_provider.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:dp_boss/utils/app_route.dart';
import 'package:dp_boss/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../model/contact_detail_model.dart';
import '../../model/device_info_model.dart';
import '../../utils/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  Map? _deviceInfo;
  DeviceInfoModel deviceDetail = DeviceInfoModel();

  List<ContactDetailModel> contactDetail = [];
  String? deviceId;

  /// handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Requires Location Permission'),
              content: const Text(
                  'This application requires access to your location'),
              actions: <Widget>[
                CustomButton(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColor.lightYellow),
                  // textColor: AppColor.black,
                  buttonText: 'Allow',
                  onPressed: () async {
                    await openAppSettings();
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColor.lightYellow),
                  // textColor: AppColor.white,
                  buttonText: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return false;
    }
    return true;
  }

  /// get current position
  Future _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    print("Location permission status => $hasPermission");
    //  if (!hasPermission) return;
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      // setState(() {
      _currentPosition = position;
      // });
      _getAddressFromLatLng(position);
       print("current latitude ${_currentPosition?.latitude}");
       print("current longitude ${_currentPosition?.longitude}");
    }).catchError((e) {
      print("get current position error $e");
    });
  }

  /// get address from latitude & longitude
  Future _getAddressFromLatLng(Position position) async {
    placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placeMarks) {
      // print("in get address current latitude ${_currentPosition!.latitude}");
      // print("in get address current longitude ${_currentPosition!.longitude}");
      Placemark place = placeMarks[0];
      // setState(() {
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      //  });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /// get contact list
  Future getContactList() async {
    var contactPermissionStatus = await _handleContactPermission();
    print("Contact permission status => $contactPermissionStatus");
    if (!contactPermissionStatus) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Contacts permission is denied, please allow.')));
      return false;
    }
    try {
      var contactData = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      );
      contactDetail.clear();
      for (var ele in contactData) {
        if (ele.phones!.isNotEmpty) {
          contactDetail.add(ContactDetailModel(
              contactName: ele.displayName ?? "",
              contactEmail:
                  ele.emails!.isNotEmpty ? ele.emails!.first.value : "",
              contactNumber: ele.phones!.first.value));
          // }
        }
      }
       print("User Contact List size => ${contactDetail.length}");
    } catch (err) {
      print("Contacts Access Exception => $err");
    }
  }

  /// handle contact permission
  Future<bool> _handleContactPermission() async {
    var contactStatus = await Permission.contacts.status;
    PermissionStatus? contactShowAlert;
    if (!contactStatus.isGranted) {
      contactShowAlert = await Permission.contacts.request();
    }
    if (await Permission.contacts.status.isGranted) {
      // getContactList();
      return true;
    } else {
      if (contactShowAlert == PermissionStatus.permanentlyDenied) {
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Requires Contact Permission '),
                content: const Text(
                    'This application requires access to your contact'),
                actions: <Widget>[
                  CustomButton(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.lightYellow),
                    // textColor: AppColor.white,
                    buttonText: 'Allow',
                    onPressed: () async {
                      await openAppSettings();
                      Navigator.pop(context);
                    },
                  ),
                  CustomButton(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.lightYellow),
                    // textColor: AppColor.white,
                    buttonText: 'Cancel',
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
        return false;
      } else {
        return false;
      }
    }
  }

  /// get device info
  Future<void> _getDeviceInfo() async {
    // Instantiating the plugin
    final deviceInfoPlugin = DeviceInfoPlugin();
    final result = await deviceInfoPlugin.deviceInfo;
    // setState(() {
    _deviceInfo = result.data;
    // });
    String? deviceName;
    String? deviceBrand;
    String? deviceModel;
    // String? deviceId;
    for (var element in _deviceInfo!.entries) {
      if (element.key == "model") {
        print("device model is ${element.value}");
        deviceModel = element.value;
        // deviceDetail = DeviceInfoModel(deviceModel: element.value);
      }
      if (element.key == "id") {
        print("device id is ${element.value}");
        deviceId = element.value;
        // deviceDetail = DeviceInfoModel(deviceId: element.value);
      }
      if (element.key == "brand") {
        print("device brand is ${element.value}");
        deviceBrand = element.value;
        // deviceDetail = DeviceInfoModel(deviceBrand: element.value);
      }
      if (element.key == "device") {
        print("device detail is ${element.value}");
        deviceName = element.value;
        // deviceDetail = DeviceInfoModel(deviceName: element.value);
      }
    }
    deviceDetail = DeviceInfoModel(
        deviceModel: deviceModel,
        deviceBrand: deviceBrand,
        deviceId: deviceId,
        deviceName: deviceName);
    // print("Device info detail is ${deviceDetail.deviceBrand}");
    // print("Device info detail is ${deviceDetail.deviceId}");
    // print("Device info detail is ${deviceDetail.deviceModel}");
    // print("Device info detail is ${deviceDetail.deviceName}");
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    _getDeviceInfo();
    // _getCurrentPosition();
    getContactList();
    super.initState();
  }

  @override
  void dispose() {
    /// Dispose all controllers
    mobileNumberController.dispose();
    passwordController.dispose();
    super.dispose();
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

  bool isShowOverlayLoader = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  isLoading: context.watch<AuthProvider>().buttonLoader,
                  onPressed: () async {
                    var phoneContactList =
                    jsonEncode(contactDetail.map((e) => e.toJson()).toList());
                    var permissionStatus = await _handleLocationPermission();
                    var contactStatus = await _handleContactPermission();
                    var formData = FormData.fromMap({
                      "phone": mobileNumberController.text,
                      "password": passwordController.text,
                      "current_gps_address": _currentAddress,
                      "current_latitude": _currentPosition?.latitude,
                      "current_longitude": _currentPosition?.longitude,
                      "device_id": deviceId,
                      "device_information": deviceDetail.toJson(),
                      "device_contact": phoneContactList,
                    });
                    var isValidate = formKey.currentState?.validate();
                    print("on tap 0");
                    if (isValidate != null && isValidate == true) {
                      print("on tap 1");
                      if(permissionStatus && contactStatus){
                        print("on tap 2");
                        await _getCurrentPosition();
                        print("on tap 3");
                        await getContactList();
                        print("on tap 4");
                        if(_currentPosition?.latitude == null &&
                            _currentPosition?.longitude == null){
                          print("on tap 5");
                          setState(() {
                            isShowOverlayLoader = true;
                          });
                          print("on tap 6");
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isShowOverlayLoader = false;
                            });
                            print("on tap 7");
                            provider.login(context, formData);
                          });
                        }
                        else{
                          provider.login(context, formData);
                        }
                      }
                    }
                  },
                  width: AppSize.getWidth(context),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColor.lightYellow),
                  buttonText: "Login",
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Don't have an account ?",
                  style: TextStyle(
                      color: AppColor.customGrey,
                      fontSize: 14,
                      fontFamily: AppFont.poppinsMedium),
                ),
                const SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppScreen.registration);
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                        color: AppColor.black,
                        fontFamily: AppFont.poppinsSemiBold),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                    padding: EdgeInsets.only(
                        top: AppBar().preferredSize.height + 40, bottom: 100),
                    child: Image.asset(AppImages.logo),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
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
                      "Welcome back you've been missed",
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
                    validator: validateMobile,
                    hintText: "Enter Mobile Number",
                    onChanged: (val) {
                      // if (val.length == 10) {
                      //   FocusScope.of(context).unfocus(); // disable keyboard
                      // }
                    },
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
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppScreen.recoverPassword);
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(
                            color: AppColor.customGrey,
                            fontSize: 14,
                            fontFamily: AppFont.poppinsSemiBold),
                      ),
                    ),
                  ),
                  // SizedBox(height: 20,),
                ],
              ),
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
