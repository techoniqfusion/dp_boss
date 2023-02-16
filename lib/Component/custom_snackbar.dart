import 'package:flutter/material.dart';

class CustomSnackBar {
  static mySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("$message"),
      ),
    );
  }
}
