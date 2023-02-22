import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dp_boss/utils/validation.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/icon_card.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../API Response Model/Registration Model/registration_model.dart';
import '../../Component/custom_dropdown.dart';
import '../../Component/custom_loader.dart';
import '../../Component/pop_up.dart';
import '../../Component/textheading.dart';
import '../../Providers/Profile Update Provider/profile_update_provider.dart';
import '../../model/StateModel.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';
import '../../utils/db_helper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? selectedGender;
  String? selectedCity;
  String? selectedState;
  final formKey = GlobalKey<FormState>();
  List<States> newStateData = [];
  List<String> cityData = [];

  List<DropdownMenuItem<String>> get genderItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "male", child: Text("Male")),
      const DropdownMenuItem(value: "female", child: Text("Female")),
    ];
    return menuItems;
  }

  var sqliteDb = SQLService();
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var dobController = TextEditingController();
  var addressController = TextEditingController();

  @override
  void initState() {
    selectStateData();
    getUserData().then((value) => {
          fullNameController.text = value.name,
          mobileNumberController.text = value.mobile
        });
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.dispose();
  }

  selectStateData() async {
    final jsonData =
        await root_bundle.rootBundle.loadString('jsonfile/states_cities.json');
    final list = json.decode(jsonData);
    final stateData = StatesCitiesModel.fromJson(list);
    // setState(() {
    newStateData = stateData.states as List<States>;
    // });
    print("state length ${newStateData.length}");
  }

  Future getUserData() async {
    print("Call Local dataBase");
    await sqliteDb.openDB();
    try {
      List list = await sqliteDb.getUser();
      print("user data => $list");
      final data = UserData.fromJson(list.first);
      // print("user data address => ${data.address}");
      // print("user data email => ${data.email}");
      // print("user data mobile => ${data.mobile}");
      return data;
    } catch (e) {
      print(e);
    }
  }

  int selectedStateIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileUpdateProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, AppScreen.dashboard, (route) => false,
            arguments: {'key': 'Profile'}).then((value) {
          setState(() {});
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: iconCard(
              icon: SvgPicture.asset(AppImages.backIcon),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppScreen.dashboard, (route) => false,
                    arguments: {'key': 'Profile'});
              }),
          title: const Text(
            "Update Profile",
            style: TextStyle(
                fontFamily: AppFont.poppinsMedium,
                fontSize: 14,
                color: AppColor.black),
          ),
        ),
        body: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as UserData;
                print("mobile number => ${data.mobile}");

                if (data.mobile != null && data.mobile != "null") {
                  mobileNumberController.text = data.mobile ?? "";
                }

                if (data.email != null && data.email != "null") {
                  emailController.text = data.email.toString();
                }

                if (data.dob != null && data.dob != "null") {
                  dobController.text = data.dob.toString();
                }

                if (data.address != null && data.address != "null") {
                  addressController.text = data.address.toString();
                }

                if (data.gender != null && data.gender != "null") {
                  selectedGender = data.gender;
                }
                if (data.city != null && data.city != "null") {
                  print("selected city val is ${data.city}");
                  selectedCity = data.city;
                }
                if (data.state != null && data.state != "null") {
                  print("selected state val is ${data.state}");
                  selectedState = data.state;
                  selectedStateIndex = newStateData
                      .indexWhere((val) => val.state == selectedState);
                  cityData = newStateData[selectedStateIndex].districts!;
                }
                // print("selected state data  $newStateData");
                // print("selected city data  $cityData");
                return Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    children: [
                      const Text(
                        "Edit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.black,
                            fontSize: 20,
                            fontFamily: AppFont.poppinsSemiBold),
                      ),

                      textHeading(text: "Name"),

                      /// Full Name TextField
                      CustomTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z]+|\s")),
                        ], // for allow only alphabets
                        keyboardType: TextInputType.text,
                        controller: fullNameController,
                        validator: Validation.validate,
                        horizontalContentPadding: 30,
                        hintText: "Enter Full Name",
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "Email"),

                      /// Email TextField
                      CustomTextField(
                        controller: emailController,
                        validator: Validation.validateEmail,
                        horizontalContentPadding: 30,
                        hintText: "Enter Email",
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "Mobile"),

                      /// Mobile TextField
                      CustomTextField(
                        controller: mobileNumberController,
                        readOnly: true,
                        horizontalContentPadding: 30,
                        hintText: "Enter Mobile Number",
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "Gender"),

                      /// Select Gender Dropdown
                      StatefulBuilder(builder: (context, setDropDown) {
                        return CustomDropdown(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hint: const Text("select gender"),
                          validator: (value) =>
                              value == null ? 'Required' : null,
                          // dropdownColor: Colors.blueAccent,
                          value: selectedGender,
                          onChanged: (newValue) {
                            setDropDown(() {
                              selectedGender = newValue.toString();
                            });
                          },
                          items: genderItems,
                        );
                      }),

                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "DOB"),

                      /// DOB TextField
                      CustomTextField(
                        onTap: () {
                          _selectDate(context);
                        },
                        readOnly: true,
                        validator: Validation.validate,
                        controller: dobController,
                        horizontalContentPadding: 30,
                        hintText: "Enter DOB",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColor.customGrey,
                              )),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "Address"),

                      /// Address TextField
                      CustomTextField(
                        validator: Validation.validate,
                        controller: addressController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z\d]+|\s")),
                        ],
                        // verticalContentPadding: 10,
                        keyboardType: TextInputType.multiline,
                        horizontalContentPadding: 30,
                        hintText: "Enter Address",
                      ),

                      /// Select City Dropdown
                      const SizedBox(
                        height: 20,
                      ),

                      textHeading(text: "Select State"),

                      StatefulBuilder(builder: (context, setDropDown) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              hint: const Text("choose state"),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                              value: selectedState,
                              onChanged: (val) {
                                setDropDown(() {
                                  selectedState = val.toString();
                                  selectedStateIndex = newStateData.indexWhere(
                                      (val) => val.state == selectedState);
                                  cityData = newStateData[selectedStateIndex]
                                      .districts!;
                                  selectedCity = null;
                                });
                              },
                              items: newStateData
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.state,
                                        child: Text(
                                          '${item.state}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            textHeading(text: "Select City"),
                            CustomDropdown(
                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                hint: const Text("choose city"),
                                validator: (value) =>
                                    value == null ? 'Required' : null,
                                value: selectedCity,
                                onChanged: selectedState != null
                                    ? (val) {
                                        setDropDown(() {
                                          selectedCity = val.toString();
                                        });
                                        print("selected city $selectedCity");
                                      }
                                    : null,
                                items: cityData.map((item) {
                                  // print('city list $item');
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList())
                          ],
                        );
                      }),

                      SizedBox(height: 20,),

                      CustomButton(
                          onPressed: () async {
                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                            // var authToken = prefs.getString("userToken");
                            // print("user token ${authToken}");
                            var isValidate = formKey.currentState?.validate();
                            if (isValidate != null && isValidate == true) {
                              var formData = FormData.fromMap({
                                "email": emailController.text,
                                "state": selectedState,
                                "dob": dobController.text,
                                "gender": selectedGender,
                                "city": selectedCity,
                                "address": addressController.text,
                              });
                              final response =
                              await provider.updateProfile(context, formData);
                              if (response['status_code'] == 200) {
                                popUp(
                                  context: context,
                                  title: response['message'], // show popUp
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, AppScreen.dashboard, (route) => false,
                                            arguments: {'key': 'Profile'}).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: const Text("okay"),
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                          isLoading:
                          context.watch<ProfileUpdateProvider>().profileUpdateLoader,
                          backgroundColor:
                          MaterialStateProperty.all<Color>(AppColor.lightYellow),
                          buttonText: "Submit"),
                    ],
                  ),
                );
              } else {
                return customLoader();
              }
            }),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedDate.year - 18),
      firstDate: DateTime(selectedDate.year - 75),
      lastDate: DateTime(selectedDate.year - 18),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.yellow,
              onPrimary: AppColor.white,
              onSurface: AppColor.black,
            ),
            // textButtonTheme: TextButtonThemeData(
            //   style: TextButton.styleFrom(
            //     primary: Colors.red, // button text color
            //   ),
            // ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      // setState(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dobController.text = formattedDate;
      // });
    }
  }
}
