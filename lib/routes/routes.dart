import 'package:flutter/material.dart';
import '../screen/home.dart';
import '../screen/inspiration/inspiration_history.dart';
import '../screen/inspiration/inspiration_history_details.dart';
import '../screen/account/user.dart';
import '../screen/setting/setting.dart';
import '../screen/setting/account.dart';
import '../screen/setting/change_skin.dart';
import '../screen/my/history.dart';
import '../screen/my/favourites.dart';
import '../screen/laboratory.dart';
import '../screen/about.dart';
import '../screen/webview.dart';

class Routes {
  static Map<String, WidgetBuilder> mappingList = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage(),
    '/inspiration_history': (BuildContext context) => InspirationHistoryPage(),
    '/inspiration_history_details': (BuildContext context) =>
        InspirationHistoryDetailsPage(),
    '/login': (BuildContext context) => InheritedUserPageContainer(),
    '/setting': (BuildContext context) => SettingPage(),
    '/account': (BuildContext context) => AccountPage(),
    '/change_skin': (BuildContext context) => SkinPage(),
    '/laboratory': (BuildContext context) => LaboratoryPage(),
    '/about': (BuildContext context) => AboutPage(),
    '/history': (BuildContext context) => HistoryPage(),
    '/favourites': (BuildContext context) => FavouritesPage(),
    '/webview': (BuildContext context) => WebviewPage(),
  };
}
