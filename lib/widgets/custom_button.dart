import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final double paddingVertical;
  final double paddingHorizontal;
  final VoidCallback callback;
  CustomButton({
    @required this.text,
    @required this.textColor,
    @required this.bgColor,
    @required this.borderColor,
    this.paddingVertical = 16,
    this.paddingHorizontal = 50,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      color: bgColor,
      elevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: 'SoukouMincho',
          fontSize: 18,
          letterSpacing: 1.5,
        ),
      ),
      onPressed: () => callback(),
    );
  }
}
