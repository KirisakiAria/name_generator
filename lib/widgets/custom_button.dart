import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final double fontSize;
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
    this.fontSize = 18,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(bgColor),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: 'SoukouMincho',
          fontSize: fontSize,
          letterSpacing: 1.5,
        ),
      ),
      onPressed: () => callback(),
    );
  }
}
