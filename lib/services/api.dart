class API {
  //所有请求头都带此密钥
  static const String secret = '0Q3prsna4TLry26Zmu2bPnpl6hM2fw';
  static const String origin = 'http://localhost:8888';
  static const String version = 'v1';
  static const String api_prefix = '$origin/api/$version';
  static const String word = '/word/random';
  static const String history = '/user/history';
  static const String favourite = '/user/favourite';
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String changePassword = '/user/changepassword';
  static const String getAuthCode = '/sendcode';
  static const String getUserData = '/user/getdata';
  static const String upload = '/upload';
  static const String changeAvatar = '/user/avatar';
  static const String changeUsername = '/user/username';
}
