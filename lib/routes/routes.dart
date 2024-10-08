import 'package:flutter/material.dart';
import '../screen/home.dart';
import '../screen/inspiration/inspiration_history.dart';
import '../screen/inspiration/inspiration_history_details.dart';
import '../screen/account/user.dart';
import '../screen/account/account.dart';
import '../screen/account/order.dart';
import '../screen/account/vip.dart';
import '../screen/setting/setting.dart';
import '../screen/setting/change_skin.dart';
import '../screen/my/history.dart';
import '../screen/my/favourite.dart';
import '../screen/my/laboratory.dart';
import '../screen/my/about.dart';
import '../screen/webview.dart';
import '../screen/notification/notifications.dart';

class Routes {
  static Map<String, WidgetBuilder> mappingList = <String, WidgetBuilder>{
    '/home': (BuildContext context) => HomePage(),
    '/inspiration_history': (BuildContext context) => InspirationHistoryPage(),
    '/inspiration_history_details': (BuildContext context) =>
        InspirationHistoryDetailsPage(),
    '/login': (BuildContext context) => InheritedUserPageContainer(),
    '/setting': (BuildContext context) => SettingPage(),
    '/account': (BuildContext context) => AccountPage(),
    '/vip': (BuildContext context) => VipPage(),
    '/order': (BuildContext context) => OrderPage(),
    '/change_skin': (BuildContext context) => SkinPage(),
    '/laboratory': (BuildContext context) => LaboratoryPage(),
    '/about': (BuildContext context) => AboutPage(),
    '/favourites': (BuildContext context) => FavouritePage(),
    '/history': (BuildContext context) => HistoryPage(),
    '/webview': (BuildContext context) => WebviewPage(),
    '/notifications': (BuildContext context) => NotificationPage(),
  };
}
