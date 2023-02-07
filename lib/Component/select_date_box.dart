import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../utils/app_color.dart';
import '../utils/app_images.dart';

class SelectDateBox extends StatefulWidget {
    String? chooseDate;
    SelectDateBox({Key? key, required this.chooseDate}) : super(key: key);

  @override
  State<SelectDateBox> createState() => _SelectDateBoxState();
}

class _SelectDateBoxState extends State<SelectDateBox> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        gradient: AppColor.yellowGradient2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.chooseDate == null ? "select date" :"${widget.chooseDate}".split(' ')[0],style: const TextStyle(
            color: AppColor.black
          ),),
          InkWell(
              onTap: (){
                _selectDate(context);
              },
              child: SvgPicture.asset(AppImages.calendarIcon))
          // IconButton(onPressed: (){
          //   _selectDate(context);
          // }, icon: )
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
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
          );}
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        widget.chooseDate = formattedDate;
      });
    }
  }
}
