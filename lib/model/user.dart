import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '未登录';
  String _tel = '';
  int _uid = 0;
  bool _vip = false;
  String _avatar = '/avatar/avatar.png';
  String _date = '';
  String _token = '';
  bool _loginState = false;
  String _vipStartTime = '';
  String _vipEndTime = '';

  String get username => _username;
  String get tel => _tel;
  int get uid => _uid;
  bool get vip => _vip;
  String get avatar => _avatar;
  String get date => _date;
  String get token => _token;
  bool get loginState => _loginState;
  String get vipStartTime => _vipStartTime;
  String get vipEndTime => _vipEndTime;

  void changeUserData({
    String username,
    String tel,
    int uid,
    bool vip,
    String avatar,
    String date,
    String token,
    bool loginState,
    String vipStartTime,
    String vipEndTime,
  }) {
    _username = username ?? _username;
    _tel = tel ?? _tel;
    _uid = uid ?? _uid;
    _vip = vip ?? _vip;
    _avatar = avatar ?? _avatar;
    _date = date ?? _date;
    _token = token ?? _token;
    _loginState = loginState ?? _loginState;
    _vipStartTime = vipStartTime ?? _vipStartTime;
    _vipEndTime = vipEndTime ?? _vipEndTime;
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

  void changeVip(bool vip) {
    _vip = vip;
    notifyListeners();
  }

  void logOut() {
    _username = '未登录';
    _tel = tel;
    _uid = 0;
    _vip = false;
    _avatar = '/avatar/avatar.png';
    _date = '';
    _token = '';
    _loginState = false;
    _vipStartTime = '';
    _vipEndTime = '';
    notifyListeners();
  }
}
