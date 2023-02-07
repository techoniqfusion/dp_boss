import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/icon_card.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../API Response Model/Registration Model/registration_model.dart';
import '../../Component/custom_dropdown.dart';
import '../../Component/custom_loader.dart';
import '../../Component/textheading.dart';
import '../../Providers/Profile Update Provider/profile_update_provider.dart';
import '../../model/StateModel.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
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
          emailController.text = value.email,
          dobController.text = value.dob,
          addressController.text = value.address,
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

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validate(String? value) {
    if (value!.isEmpty) {
      return "Required";
    }
    return null;
  }

  Future getUserData() async {
    print("Call Local dataBase");
    await sqliteDb.openDB();
    try {
      List list = await sqliteDb.getUser();
      final data = UserData.fromJson(list.first);
      print("user data address => ${data.address}");
      print("user data email => ${data.email}");
      return data;
    } catch (e) {
      print(e);
    }
  }

  int selectedStateIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileUpdateProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: CustomButton(
            onPressed: () async {
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
                provider.updateProfile(context, formData);
                FocusScope.of(context).unfocus();
              }
            },
            isLoading:
                context.watch<ProfileUpdateProvider>().profileUpdateLoader,
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.lightYellow),
            buttonText: "Submit"),
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
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
              print("get user data is ${snapshot.data}");
              var data = snapshot.data as UserData;

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
              }

              return Form(
                key: formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                    CustomTextField(
                      controller: fullNameController,
                      validator: validate,
                      horizontalContentPadding: 30,
                      hintText: "Enter Full Name",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textHeading(text: "Email"),

                    CustomTextField(
                      controller: emailController,
                      validator: validateEmail,
                      horizontalContentPadding: 30,
                      hintText: "Enter Email",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textHeading(text: "Mobile"),
                    CustomTextField(
                      controller: mobileNumberController..text = data.mobile ?? "",
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
                            value == null ? "Select gender" : null,
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
                    CustomTextField(
                      readOnly: true,
                      validator: validate,
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
                    CustomTextField(
                      validator: validate,
                      controller: addressController,
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
                              setState(() {
                                selectedState = val.toString();
                                selectedStateIndex = newStateData.indexWhere(
                                    (val) => val.state == selectedState);
                                cityData =
                                    newStateData[selectedStateIndex].districts!;
                                selectedCity = null;
                              });
                              print(
                                  "city data length ${cityData.length} and $selectedState");
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            hint: const Text("choose city"),
                            validator: (value) =>
                                value == null ? "Select City" : null,
                            value: selectedCity,
                            onChanged: (val) {
                              setDropDown(() {
                                selectedCity = val.toString();
                              });
                              print("selected city $selectedCity");
                            },
                            items: selectedState != null
                                ? cityData.map((item) {
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
                                  }).toList()
                                : [],
                          )
                        ],
                      );
                    }),

                    // CustomTextField(
                    //   controller: stateController..text = data.state.toString(),
                    //   validator: validate,
                    //   // verticalContentPadding: 10,
                    //   horizontalContentPadding: 30,
                    //   hintText: "State",
                    // ),
                  ],
                ),
              );
            } else {
              return customLoader();
            }
          }),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
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