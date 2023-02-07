import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class CustomDropdown extends StatelessWidget {
  final String? labelText;
  final Widget? hint;
  final String? Function(Object?)? validator;
  final void Function(Object?)? onChanged;
  final List<DropdownMenuItem<Object>>? items;
  final Object? value;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;
  const CustomDropdown(
      {Key? key,
        this.labelText,
        this.hint,
        this.validator,
        required this.onChanged,
        required this.items,
        this.value,
        this.autovalidateMode, this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        iconSize: 30,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        autovalidateMode: autovalidateMode,
        hint: hint,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black),
          labelText: labelText,
          contentPadding: const EdgeInsets.only(left: 30,right: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide( color: AppColor.customGrey,),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red,),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide( color: AppColor.customGrey,),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide( color: AppColor.customGrey,),
          ),
        ),
        validator: validator,
        value: value,
        onChanged: onChanged,
        items: items);
  }
}
