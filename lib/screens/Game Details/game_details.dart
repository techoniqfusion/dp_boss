import 'package:dp_boss/Component/custom_button.dart';
import 'package:dp_boss/Component/custom_textfield.dart';
import 'package:dp_boss/Component/textheading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../Component/icon_card.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_images.dart';

class GameDetails extends StatefulWidget {
  final String gameType;
  final String points;
  const GameDetails({Key? key, required this.gameType, required this.points})
      : super(key: key);

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  String? groupValue;
  var gameTypeController = TextEditingController();
  var pointsController = TextEditingController();

  @override
  void dispose() {
    gameTypeController.dispose();
    pointsController.dispose();
    super.dispose();
  }

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
          widget.gameType,
          style: TextStyle(
              fontFamily: AppFont.poppinsMedium,
              fontSize: 14,
              color: AppColor.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          SizedBox(height: 20,),
          textHeading(text: "Choose Session"),
          StatefulBuilder(builder: (context, setRadio) {
            return Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Open"),
                    value: "open",
                    groupValue: groupValue,
                    onChanged: (val) {
                      groupValue = val;
                      setRadio(() {});
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: Text("Close"),
                      value: "close",
                      groupValue: groupValue,
                      onChanged: (val) {
                        groupValue = val;
                        setRadio(() {});
                      }),
                )
              ],
            );
          }),
          textHeading(text: widget.gameType),
          CustomTextField(
            controller: gameTypeController,
            hintText: "Enter ${widget.gameType} Number",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"\d"), // allow only numbers
              )
            ],
          ),
          SizedBox(height: 20,),
          textHeading(text: "Points"),
          CustomTextField(
            controller: pointsController,
            hintText: "Enter Points",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"\d"), // allow only numbers
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            buttonText: "Submit",
            backgroundColor: MaterialStatePropertyAll(AppColor.lightYellow),
          ),
          SizedBox(height: 30,),
          Text(
            "Total Points : ${widget.points}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColor.black,
                fontFamily: AppFont.poppinsBold,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
