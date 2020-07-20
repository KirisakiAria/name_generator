import 'package:flutter/material.dart';
import '../screen/home.dart';
import '../screen/user.dart';
import '../screen/setting.dart';
import '../screen/account.dart';

class Routes {
  static Map<String, WidgetBuilder> mappingList = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage(),
    '/login': (BuildContext context) => InheritedUserPageContainer(),
    '/setting': (BuildContext context) => SettingPage(),
    '/account': (BuildContext context) => AccountPage(),
  };
}
