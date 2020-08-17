import 'package:flutter/foundation.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '未登录';
  String _tel;
  int _uid = 0;
  String _avatar = '/avatar/avatar.png';
  String _date = '';
  String _token;
  bool _loginState = false;

  String get username => _username;
  String get tel => _tel;
  int get uid => _uid;
  String get avatar => _avatar;
  String get date => _date;
  String get token => _token;
  bool get loginState => _loginState;

  void changeUserData({
    @required String username,
    @required String tel,
    @required int uid,
    @required String avatar,
    @required String date,
    @required String token,
    @required bool loginState,
  }) {
    _username = username;
    _tel = tel;
    _uid = uid;
    _avatar = avatar;
    _date = date;
    _token = token;
    _loginState = loginState;
    notifyListeners();
  }

  void changeAvatar(avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  void changeUsername(username) {
    _username = username;
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
