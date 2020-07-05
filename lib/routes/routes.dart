import 'package:flutter/material.dart';
import '../screen/home.dart';
import '../screen/my.dart';

class Routes {
  static Map<String, WidgetBuilder> mappingList = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage(),
    '/my': (BuildContext context) => MyPage(),
  };
  static List<String> bottomNavigationBarRouteList = <String>['/home', '/my'];
}
