import 'package:dp_boss/utils/app_font.dart';
import 'package:flutter/material.dart';
import '../../../../Component/dot.dart';
import '../../../../Component/select_date_box.dart';

class WinningHistory extends StatefulWidget {
  const WinningHistory({Key? key}) : super(key: key);

  @override
  State<WinningHistory> createState() => _WinningHistoryState();
}

class _WinningHistoryState extends State<WinningHistory> {
  String? winningStartDate;
  String? winningEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Select Date",
              style:
                  TextStyle(fontSize: 16, fontFamily: AppFont.poppinsRegular),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: SelectDateBox(
                  chooseDate: winningStartDate,
                )),
                dot(),
                dot(),
                dot(rightMargin: 5),
                Expanded(
                    child: SelectDateBox(
                  chooseDate: winningEndDate,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
