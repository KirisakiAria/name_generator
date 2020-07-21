import 'package:flutter/foundation.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '未登录';
  String _tel;
  int _uid = 0;
  String _avatar = '/avatar.png';
  String _token;
  bool _loginState = false;

  String get username => _username;
  String get tel => _tel;
  int get uid => _uid;
  String get avatar => _avatar;
  String get token => _token;
  bool get loginState => _loginState;

  void changeOptions({
    String username,
    String tel,
    int uid,
    String avatar,
    String token,
    bool loginState,
  }) {
    _username = username;
    _tel = tel;
    _uid = uid;
    _avatar = avatar;
    _token = token;
    _loginState = loginState;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('username', username));
    properties.add(StringProperty('tel', tel));
    properties.add(StringProperty('avatar', avatar));
    properties.add(StringProperty('token', token));
  }
}
