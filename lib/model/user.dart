import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '未登录';
  String _tel;
  int _uid = 0;
  String _avatar = '/avatar/avatar.png';
  String _date = '';
  String _token = '';
  bool _loginState = false;

  String get username => _username;
  String get tel => _tel;
  int get uid => _uid;
  String get avatar => _avatar;
  String get date => _date;
  String get token => _token;
  bool get loginState => _loginState;

  void changeUserData({
    String username,
    String tel,
    int uid,
    String avatar,
    String date,
    String token,
    bool loginState,
  }) {
    _username = username ?? _username;
    _tel = tel ?? _tel;
    _uid = uid ?? _uid;
    _avatar = avatar ?? _avatar;
    _date = date ?? _date;
    _token = token ?? _token;
    _loginState = loginState ?? _loginState;
    notifyListeners();
  }

  void changeAvatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  void changeUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void changeToken(String token) {
    _token = token;
    notifyListeners();
  }

  void logOut() {
    _username = '未登录';
    _tel = tel;
    _uid = 0;
    _avatar = '/avatar/avatar.png';
    _date = '';
    _token = '';
    _loginState = false;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('username', username));
    properties.add(StringProperty('tel', tel));
    properties.add(IntProperty('uid', uid));
    properties.add(StringProperty('avatar', avatar));
    properties.add(StringProperty('date', date));
    properties.add(StringProperty('token', token));
  }
}
