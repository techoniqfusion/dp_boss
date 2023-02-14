import 'package:dp_boss/screens/Dashboard/History%20Screen/Bidding%20History/bidding_history.dart';
import 'package:dp_boss/utils/app_color.dart';
import 'package:flutter/material.dart';

import 'Winning History/winning_history.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // print("withdraw record init called!..");
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TabBar(
            controller: _tabController,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            // indicator: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30), // Creates border
            //     color: AppColor.yellow1),
            labelColor: AppColor.black,
            unselectedLabelColor: AppColor.iconGrey,
            indicatorColor: AppColor.yellow1,
            tabs: const [
              Tab(
                text: "Winning",
              ),
              Tab(
                text: "Bidding",
                // child: Text("Deposit"),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                WinningHistory(),
                BiddingHistory()
              ]
            ),
          ),
        ],
      )
    );
  }
}
