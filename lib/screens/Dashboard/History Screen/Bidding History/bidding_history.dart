import 'package:flutter/material.dart';
import '../../../../Component/dot.dart';
import '../../../../Component/select_date_box.dart';
import '../../../../utils/app_font.dart';

class BiddingHistory extends StatefulWidget {
  const BiddingHistory({Key? key}) : super(key: key);

  @override
  State<BiddingHistory> createState() => _BiddingHistoryState();
}

class _BiddingHistoryState extends State<BiddingHistory> {

  String? chooseData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("Select Date",style: TextStyle(
                fontSize: 16,
                fontFamily: AppFont.poppinsRegular
            ),),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: SelectDateBox(chooseDate: chooseData,)
                ),
                dot(),dot(),dot(rightMargin: 5),
                Expanded(
                    child: SelectDateBox(chooseDate: chooseData,)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
