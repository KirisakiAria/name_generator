import 'package:flutter/foundation.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin {
  String _tel;
  String _avatar;
  String _token;

  String get tel => _tel;
  String get avatar => _avatar;
  String get token => _token;

  void changeOptions({String type, String number}) {
    _tel = tel;
    _avatar = avatar;
    _token = token;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tel', tel));
    properties.add(StringProperty('avatar', avatar));
    properties.add(StringProperty('token', token));
  }
}
