import 'package:dp_boss/API%20Response%20Model/Bank%20Details%20List%20Model/bank_details_list_model.dart';
import 'package:dp_boss/Providers/Bank%20Details%20List%20Provider/bank_details_list_provider.dart';
import 'package:dp_boss/utils/app_color.dart';
import 'package:dp_boss/utils/app_font.dart';
import 'package:dp_boss/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_loader.dart';
import '../../../Component/try_again.dart';
import '../../../utils/app_route.dart';

class AccountView extends StatefulWidget {

   const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<BankDetailsListProvider>(context, listen: false);
    return Scaffold(
        body: FutureBuilder(
          future: provider.bankDetails(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.done) if (snapshot.hasData) {
              final bankDetailList = snapshot.data as BankDetailsListModel;
              // var descendingOrder = bankDetailList.reversed.toList();
              // print("History data is ${historyData.first.subject}");
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bank Account",
                      style: TextStyle(
                        color: AppColor.black,
                        fontFamily: AppFont.poppinsSemiBold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Setup Bank Account",
                      style: TextStyle(color: AppColor.black, fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    addAccountTile(
                        text: "Add New Bank Account",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppScreen.addBankAccount);
                        }),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Visibility(
                      visible: bankDetailList.data?.isNotEmpty ?? false,
                      child: ListView.builder(
                        itemCount: bankDetailList.data?.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            minLeadingWidth: 0,
                            leading: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: AppColor.lightYellow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.account_balance_outlined,
                                color: AppColor.black,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bankDetailList.data?[index].bankName ??
                                      "",
                                  style: const TextStyle(
                                      color: AppColor.black,
                                      fontSize: 14,
                                      fontFamily: AppFont.poppinsSemiBold),
                                ),
                                Text(
                                  bankDetailList
                                          .data?[index].accountNumber ??
                                      "",
                                  style: TextStyle(color: AppColor.black),
                                ),
                                Text(bankDetailList
                                        .data?[index].accountIfscCode ??
                                    "")
                              ],
                            ),
                          );
                        },
                      ),
                    ),

//------------------------------ may be show later -----------------------------

                    // Text(
                    //   "UPI",
                    //   style: TextStyle(
                    //     color: AppColor.black,
                    //     fontFamily: AppFont.poppinsSemiBold,
                    //     fontSize: 16,
                    //   ),
                    // ),
                    //
                    // Text(
                    //   "Setup your UPI ID for secure payment",
                    //   style: TextStyle(color: AppColor.black, fontSize: 14),
                    // ),
                    //
                    // ListTile(
                    //   minLeadingWidth: 0,
                    //   leading: Image.asset(
                    //     AppImages.paytmIcon,
                    //     height: 9,
                    //   ),
                    //   title: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Paytm",
                    //         style: TextStyle(
                    //             color: AppColor.black, fontSize: 14),
                    //       ),
                    //       Visibility(
                    //         visible: bankDetailList
                    //                 .phoneData?.paytm?.isNotEmpty ??
                    //             false,
                    //         child: Text(
                    //           bankDetailList.phoneData?.paytm ?? "",
                    //           style: TextStyle(color: AppColor.black),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   trailing: TextButton(
                    //     child: Text(
                    //       bankDetailList.phoneData!.paytm!.isEmpty
                    //           ? "add"
                    //           : "update",
                    //       style: TextStyle(color: AppColor.black),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pushNamed(
                    //           context, AppScreen.addUpiScreen, arguments: {
                    //         "upiType": "Paytm",
                    //         "upiId": bankDetailList.phoneData?.paytm
                    //       });
                    //     },
                    //   ),
                    // ),
                    //
                    // ListTile(
                    //   minLeadingWidth: 0,
                    //   leading: Image.asset(
                    //     AppImages.googlePayIcon,
                    //     height: 20,
                    //   ),
                    //   title: Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 6.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Google Pay",
                    //           style: TextStyle(
                    //               color: AppColor.black, fontSize: 14),
                    //         ),
                    //         Visibility(
                    //           visible: bankDetailList
                    //                   .phoneData?.gpay?.isNotEmpty ??
                    //               false,
                    //           child: Text(
                    //             bankDetailList.phoneData?.gpay ?? "",
                    //             style: TextStyle(color: AppColor.black),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   trailing: TextButton(
                    //     child: Text(
                    //       bankDetailList.phoneData!.gpay!.isNotEmpty
                    //           ? "update"
                    //           : "add",
                    //       style: TextStyle(color: AppColor.black),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pushNamed(
                    //           context, AppScreen.addUpiScreen, arguments: {
                    //         "upiType": "Google Pay",
                    //         "upiId": bankDetailList.phoneData?.gpay
                    //       });
                    //     },
                    //   ),
                    // ),
                    //
                    // ListTile(
                    //   minLeadingWidth: 0,
                    //   leading: Image.asset(
                    //     AppImages.phonePeIcon,
                    //     height: 20,
                    //   ),
                    //   title: Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 10.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Phone Pay",
                    //           style: TextStyle(
                    //               color: AppColor.black, fontSize: 14),
                    //         ),
                    //         Visibility(
                    //           visible: bankDetailList
                    //                   .phoneData?.phonepe?.isNotEmpty ??
                    //               false,
                    //           child: Text(
                    //             bankDetailList.phoneData?.phonepe ?? "",
                    //             style: TextStyle(color: AppColor.black),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   trailing: TextButton(
                    //     child: Text(
                    //       bankDetailList.phoneData!.phonepe!.isNotEmpty
                    //           ? "update"
                    //           : "add",
                    //       style: TextStyle(color: AppColor.black),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pushNamed(
                    //           context, AppScreen.addUpiScreen, arguments: {
                    //         "upiType": "PhonePay",
                    //         "upiId": bankDetailList.phoneData?.phonepe
                    //       });
                    //     },
                    //   ),
                    // ),
                    //
                    // ListTile(
                    //   minLeadingWidth: 0,
                    //   leading: Text(
                    //     "UPI",
                    //     style: TextStyle(color: AppColor.black),
                    //   ),
                    //   title: Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(horizontal: 10.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "UPI",
                    //           style: TextStyle(
                    //               color: AppColor.black, fontSize: 14),
                    //         ),
                    //         Visibility(
                    //           visible: bankDetailList
                    //                   .phoneData?.upiId?.isNotEmpty ??
                    //               false,
                    //           child: Text(
                    //             bankDetailList.phoneData?.upiId != null
                    //                 ? "update"
                    //                 : "add",
                    //             style: TextStyle(color: AppColor.black),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   trailing: TextButton(
                    //     child: Text(
                    //       bankDetailList.phoneData!.upiId!.isNotEmpty
                    //           ? "update"
                    //           : "add",
                    //       style: TextStyle(color: AppColor.black),
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pushNamed(
                    //           context, AppScreen.addUpiScreen, arguments: {
                    //         "upiType": "UPI",
                    //         "upiId": bankDetailList.phoneData?.upiId
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              return tryAgain(onTap: () => setState(() {}));
            }
            return customLoader();
          },
        ));
  }

  Widget addAccountTile({void Function()? onPressed, required String text}) {
    return ListTile(
      minLeadingWidth: 0,
      onTap: onPressed,
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColor.lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
            onPressed: onPressed,
            icon: const Text(
              "+",
              style: TextStyle(
                  color: AppColor.black, fontFamily: AppFont.poppinsSemiBold),
            )),
      ),
      title: Text(
        text,
        style: const TextStyle(
            color: AppColor.black,
            fontSize: 14,
            fontFamily: AppFont.poppinsSemiBold),
      ),
    );
  }
}
