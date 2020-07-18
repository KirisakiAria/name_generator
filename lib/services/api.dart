class API {
  //所有请求头都带此密钥
  static const String secret = '0Q3prsna4TLry26Zmu2bPnpl6hM2fw';
  static const String origin = 'http://localhost:8888';
  static const String version = 'v1';
  static const String api_prefix = '$origin/api/$version';
  static const String name = '/name';
  static const String login = '/login';
  static const String register = '/register';
  static const String getAuthCode = '/sendcode';
}
