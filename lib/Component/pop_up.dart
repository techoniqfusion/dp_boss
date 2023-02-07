import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future popUp({required BuildContext context, required String title,
  List<Widget> actions = const <Widget>[], Widget? content
}){
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => CupertinoAlertDialog(
        title: Text(title,textAlign: TextAlign.center,),
        content: content,
        actions: actions
    ),
  );
}