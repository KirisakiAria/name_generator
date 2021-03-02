class API {
  //所有请求头都带此密钥
  static const String secret = '0Q3prsna4TLry26Zmu2bPnpl6hM2fw';
  //static const String origin = 'http://localhost:2077';
  static const String origin = 'https://api.bianzizai.com';
  static const String version = 'v1';
  static const String api_prefix = '$origin/api/$version';
  static const String host = 'https://www.bianzizai.com';
  static const String word = '/word/random';
  static const String surname = '/surname';
  static const String likeCount = '/word/likecount';
  static const String likeWord = '/word/like';
  static const String dictionary = '/word/dictionary';
  static const String search = '/word/search';
  static const String todayInspiration = '/inspiration/today';
  static const String likeInspiration = '/inspiration/like';
  static const String inspiration = '/inspiration/history';
  static const String notification = '/notification';
  static const String history = '/user/history';
  static const String favourite = '/user/favourite';
  static const String pay = '/user/pay';
  static const String paySuccess = '/user/pay/success';
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String changePassword = '/user/changepassword';
  static const String getAuthCode = '/sendcode';
  static const String getUserData = '/user/getdata';
  static const String upload = '/upload';
  static const String changeAvatar = '/user/avatar';
  static const String changeUsername = '/user/username';
  static const String error = '/information/error';
  static const String update = '/app/update';
  static const String downloadlink = '/service/downloadlink';
  static const String plan = '/plan';
  static const String paymentMethod = '/data_dictionary/paymentmethod';
  static const String order = '/order/my';
  static const String activateKey = '/key/activate';
}
