import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  String reqText;
  Color reqColor;
  CustomAlertDialog(this.reqText, this.reqColor);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: reqColor,
      title: Text(
        reqText,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
