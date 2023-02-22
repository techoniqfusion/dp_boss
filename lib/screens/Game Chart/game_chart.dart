import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class GameChart extends StatefulWidget {
  const GameChart({Key? key}) : super(key: key);

  @override
  State<GameChart> createState() => _GameChartState();
}

class _GameChartState extends State<GameChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: iconCard(
            icon: SvgPicture.asset(AppImages.backIcon),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Game Chart",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
    );
  }
}
