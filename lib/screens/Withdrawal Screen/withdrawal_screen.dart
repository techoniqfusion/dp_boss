import 'package:dio/dio.dart';
import 'package:dp_boss/API%20Integration/call_api.dart';
import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../API Response Model/Bank Details List Model/bank_details_list_model.dart';
import '../../Component/custom_loader.dart';
import '../../Component/icon_card.dart';
import '../../Component/try_again.dart';
import '../../Providers/Bank Details List Provider/bank_details_list_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';
import '../../utils/app_route.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  String? groupVal;
  String? bankId;
  var withdrawAmountController = TextEditingController();
  final appApi = AppApi();
  @override
  void dispose() {
    super.dispose();
    withdrawAmountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<BankDetailsListProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text(
            "Withdrawal",
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
                //     arguments: {'key' : 'Home'}).then((value){
                //   setState(() {});
                // });
              }),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppScreen.withdrawalAllData);
                },
                icon: Icon(
                  Icons.history,
                  color: AppColor.yellow,
                ))
          ],
        ),
        body: FutureBuilder(
          future: provider.bankDetails(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) if (snapshot
                .hasData) {
              final bankDetailList = snapshot.data as BankDetailsListModel;
              // var descendingOrder = bankDetailList.reversed.toList();
              // print("History data is ${historyData.first.subject}");
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                children: [
                  CustomTextField(
                    controller: withdrawAmountController,
                    hintText: "Enter Amount",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"\d"), // allow only numbers
                      )
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Select Bank Account",
                    style: TextStyle(color: AppColor.black, fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  bankDetailList.data != null
                      ? StatefulBuilder(
                          builder: (context, setRadio) {
                            return ListView.builder(
                              itemCount: bankDetailList.data?.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var bankDetails = bankDetailList.data?[index];
                                return RadioListTile(
                                    activeColor: AppColor.yellow,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: AppColor.lightYellow,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_outlined,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bankDetails?.bankName ?? "",
                                              style: const TextStyle(
                                                  color: AppColor.black,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppFont.poppinsSemiBold),
                                            ),
                                            Text(
                                              bankDetails?.accountNumber ?? "",
                                              style: TextStyle(
                                                  color: AppColor.black),
                                            ),
                                            Text(bankDetails?.accountIfscCode ??
                                                "")
                                          ],
                                        ),
                                      ],
                                    ),
                                    value: bankDetails?.accountNumber,
                                    groupValue: groupVal,
                                    onChanged: (val) {
                                      if (bankDetails?.accountNumber == val) {
                                        groupVal = bankDetails?.accountNumber;
                                        bankId = bankDetails?.id;
                                      }
                                      setRadio(() {});
                                    });
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Add your bank",
                            style: TextStyle(color: AppColor.black),
                          ),
                        ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                    isLoading:
                        context.watch<BankDetailsListProvider>().buttonLoader,
                    backgroundColor:
                        MaterialStatePropertyAll(AppColor.lightYellow),
                    buttonText: "Withdraw",
                    onPressed: () async {
                      if (withdrawAmountController.text.isEmpty) {
                        popUp(
                          context: context,
                          title: "Enter Amount",
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("okay"),
                            ),
                          ],
                        );
                      } else {
                        if (bankId == null) {
                          popUp(
                            context: context,
                            title: "Select Bank Account",
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("okay"),
                              ),
                            ],
                          );
                        } else {
                          var formData = FormData.fromMap({
                            "amount": withdrawAmountController.text,
                            "id": bankId
                          });
                          final response = await provider.withdrawalRequest(
                              context, formData);
                          if (response["status_code"] == 200) {
                            popUp(
                              context: context,
                              title: response["message"],
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            AppScreen.dashboard,
                                            (route) => false,
                                            arguments: {'key': 'Home'})
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: const Text("okay"),
                                ),
                              ],
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              );
            } else {
              return tryAgain(onTap: () => setState(() {}));
            }
            return customLoader();
          },
        ));
  }
}
