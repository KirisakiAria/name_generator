import 'package:flutter/material.dart';
import '../screen/home.dart';
import '../screen/user.dart';
import '../screen/setting.dart';
import '../screen/account.dart';
import '../screen/skin.dart';
import '../screen/laboratory.dart';
import '../screen/about.dart';
import '../screen/history.dart';
import '../screen/favourites.dart';
import '../screen/webview.dart';

class Routes {
  static Map<String, WidgetBuilder> mappingList = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage(),
    '/login': (BuildContext context) => InheritedUserPageContainer(),
    '/setting': (BuildContext context) => SettingPage(),
    '/account': (BuildContext context) => AccountPage(),
    '/skin': (BuildContext context) => SkinPage(),
    '/laboratory': (BuildContext context) => LaboratoryPage(),
    '/about': (BuildContext context) => AboutPage(),
    '/history': (BuildContext context) => HistoryPage(),
    '/favourites': (BuildContext context) => FavouritesPage(),
    '/webview': (BuildContext context) => WebviewPage(),
  };
}
