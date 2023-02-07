import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_color.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final String? initialValue;
  final TextCapitalization textCapitalization;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final Color? fillColor;
  final String? label;
  final bool? enabled;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final bool expands;
  final bool? filled;
  final double borderRadius;
  final TextStyle? hintStyle;
  final double? verticalContentPadding;
  final double? horizontalContentPadding;
  const CustomTextField(
      {Key? key,
        this.readOnly = false,
        this.obscureText = false,
        this.hintText,
        this.controller,
        this.prefixIcon,
        this.validator,
        this.suffixIcon,
        this.keyboardType,
        this.padding = EdgeInsets.zero,
        this.label,
        this.onTap,
        this.inputFormatters,
        this.maxLength,
        this.enabled,
        this.initialValue,
        this.onChanged,
        this.minLines,
        this.maxLines = 1,
        this.onFieldSubmitted,
        this.onSaved,
        this.onEditingComplete,
        this.textCapitalization = TextCapitalization.none,
        this.fillColor = AppColor.white, this.borderRadius = 10, this.hintStyle, this.expands = false,
        this.verticalContentPadding,
        this.horizontalContentPadding,
        this.filled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        expands: expands,
        textCapitalization: textCapitalization,
        minLines: minLines,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onSaved: onSaved,
        onChanged: onChanged,
        initialValue: initialValue,
        enabled: enabled,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onTap: onTap,
        readOnly: readOnly,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: hintStyle,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: AppColor.white,
            ),
          ),
          filled: filled,
          fillColor: fillColor,
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColor.customGrey,
            ),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: verticalContentPadding ?? 0,
              horizontal: horizontalContentPadding ?? 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColor.customGrey,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: AppColor.customGrey,
            ),
          ),
        ),
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
