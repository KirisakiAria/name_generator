import 'package:flutter/material.dart';

//主题样式配色
class Style {
  static const Color grey20 = Color(0xff333333);

  //默认
  static const Map<String, Color> defaultColor = <String, Color>{
    'background': Colors.white,
    'text': Color(0xff2f2f2f),
    'selectedItem': Color(0xff212121),
    'unselectedItem': Colors.black26,
    'border': Color(0xffa9a9a9),
    'widget': Color(0xfff5f5f5),
    'subtitle': Colors.black45,
    'infoShadow': Color.fromRGBO(0, 80, 180, 0.1),
    'button': Colors.black,
    'hint': Color(0xffa9a9a9),
    'line': Colors.black12,
    'switchThumb': Colors.white,
    'inactiveSwitchTrack': Colors.black26,
    'activeSwitchTrack': Color(0xffff6348),
    'searchInput': Color(0xfff3f3f3),
  };

  //夜间
  static const Map<String, Color> nightColor = <String, Color>{
    'background': Color(0xff121212),
    'text': Color(0xfff1f1f1),
    'selectedItem': Color(0xfff5f5f5),
    'unselectedItem': Color(0xffaeaeae),
    'border': Color(0xfff1f1f1),
    'widget': grey20,
    'subtitle': Color(0xfff1f1f1),
    'infoShadow': Color.fromRGBO(0, 0, 0, 0),
    'button': Colors.white,
    'hint': Color(0xfff1f1f1),
    'line': Color.fromRGBO(0, 0, 0, 0),
    'switchThumb': Colors.white,
    'inactiveSwitchTrack': Color(0xffbfbfbf),
    'activeSwitchTrack': Color(0xffff6348),
    'searchInput': Color(0xff4f4f4f),
  };

  //主题分类
  static final ThemeData defaultTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: defaultColor['background'],
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
    scaffoldBackgroundColor: defaultColor['background'],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: defaultColor['selectedItem'],
      unselectedItemColor: defaultColor['unselectedItem'],
      backgroundColor: defaultColor['background'],
    ),
    primaryColor: defaultColor['background'],
    accentColor: defaultColor['background'],
    dialogTheme: DialogTheme(
      backgroundColor: defaultColor['widget'],
    ),
    iconTheme: IconThemeData(
      color: Color(0xff999999),
    ),
    primaryIconTheme: IconThemeData(
      color: Color(0xff999999),
    ),
    hintColor: defaultColor['hint'],
    textTheme: TextTheme(
      button: TextStyle(
        color: defaultColor['text'],
      ),
      bodyText1: TextStyle(
        color: defaultColor['text'],
      ),
      bodyText2: TextStyle(
        color: defaultColor['text'],
      ),
      headline1: TextStyle(
        color: defaultColor['text'],
      ),
      headline2: TextStyle(
        color: defaultColor['text'],
      ),
      headline3: TextStyle(
        color: defaultColor['text'],
      ),
      headline4: TextStyle(
        color: defaultColor['text'],
      ),
      headline5: TextStyle(
        color: defaultColor['text'],
      ),
      headline6: TextStyle(
        color: defaultColor['text'],
      ),
      subtitle1: TextStyle(
        color: defaultColor['text'],
      ),
      subtitle2: TextStyle(
        color: defaultColor['text'],
      ),
    ),
  );

  static final ThemeData nightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: nightColor['background'],
      iconTheme: IconThemeData(
        color: nightColor['text'],
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18,
          color: nightColor['text'],
          height: 1.1,
        ),
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: nightColor['background'],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: nightColor['selectedItem'],
      unselectedItemColor: nightColor['unselectedItem'],
      backgroundColor: nightColor['background'],
    ),
    primaryColor: nightColor['widget'],
    accentColor: nightColor['widget'],
    dialogTheme: DialogTheme(
      backgroundColor: nightColor['widget'],
    ),
    iconTheme: IconThemeData(
      color: nightColor['text'],
    ),
    primaryIconTheme: IconThemeData(
      color: nightColor['text'],
    ),
    hintColor: nightColor['hint'],
    textTheme: TextTheme(
      button: TextStyle(
        color: nightColor['text'],
      ),
      bodyText1: TextStyle(
        color: nightColor['text'],
      ),
      bodyText2: TextStyle(
        color: nightColor['text'],
      ),
      headline1: TextStyle(
        color: nightColor['text'],
      ),
      headline2: TextStyle(
        color: nightColor['text'],
      ),
      headline3: TextStyle(
        color: nightColor['text'],
      ),
      headline4: TextStyle(
        color: nightColor['text'],
      ),
      headline5: TextStyle(
        color: nightColor['text'],
      ),
      headline6: TextStyle(
        color: nightColor['text'],
      ),
      subtitle1: TextStyle(
        color: nightColor['text'],
      ),
      subtitle2: TextStyle(
        color: nightColor['text'],
      ),
      caption: TextStyle(
        color: nightColor['text'],
      ),
    ),
  );

  static const List<Map<String, Color>> colorList = <Map<String, Color>>[
    defaultColor,
    nightColor,
  ];

  static final List<ThemeData> themeList = <ThemeData>[
    defaultTheme,
    nightTheme,
  ];

  static final List<String> themeNameList = <String>[
    '默认',
    '夜间',
  ];
}
