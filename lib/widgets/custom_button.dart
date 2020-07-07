import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final void Function() callback;
  CustomButton(
      {@required this.text,
      this.textColor = Colors.white,
      this.bgColor = Colors.black,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      color: bgColor,
      elevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: () => callback(),
    );
  }
}
