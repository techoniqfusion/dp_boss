import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class SupremeDay extends StatefulWidget {
  final String id;
  const SupremeDay({Key? key, required this.id}) : super(key: key);

  @override
  State<SupremeDay> createState() => _SupremeDayState();
}

class _SupremeDayState extends State<SupremeDay> {
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
          "Supreme Day",
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
    );
  }
}
