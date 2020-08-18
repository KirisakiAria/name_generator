import 'package:flutter/material.dart';

class Style {
  static const int mainColor = 0xFF2f2f2f;
  static const int grey20 = 0xFF333333;
  static const int borderColor = 0xFFb2b2b2;
  static const int unselectedItemColor = 0xFFb2b2b2;
  static const int nightColor = 0xFF121212;
  static final ThemeData defaultTheme = ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black87,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          height: 1.1,
        ),
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(mainColor),
      unselectedItemColor: Colors.black38,
      backgroundColor: Colors.white,
    ),
    primaryColor: Colors.white,
    accentColor: Colors.white,
    textTheme: TextTheme(
      button: TextStyle(
        color: Color(mainColor),
      ),
      bodyText1: TextStyle(
        color: Color(mainColor),
      ),
      bodyText2: TextStyle(
        color: Color(mainColor),
      ),
      headline1: TextStyle(
        color: Color(mainColor),
      ),
      headline2: TextStyle(
        color: Color(mainColor),
      ),
      headline3: TextStyle(
        color: Color(mainColor),
      ),
      headline4: TextStyle(
        color: Color(mainColor),
      ),
      headline5: TextStyle(
        color: Color(mainColor),
      ),
      headline6: TextStyle(
        color: Color(mainColor),
      ),
      subtitle1: TextStyle(
        color: Color(mainColor),
      ),
      subtitle2: TextStyle(
        color: Color(mainColor),
      ),
    ),
  );
  static final ThemeData nightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(grey20),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18,
          color: Colors.white,
          height: 1.1,
        ),
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: Color(grey20),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(nightColor),
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(unselectedItemColor),
    ),
    primaryColor: Color(grey20),
    accentColor: Color(grey20),
    textTheme: TextTheme(
      button: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
      headline1: TextStyle(
        color: Colors.white,
      ),
      headline2: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
      headline4: TextStyle(
        color: Colors.white,
      ),
      headline5: TextStyle(
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
