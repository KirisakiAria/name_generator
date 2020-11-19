class Utils {
  //手机号
  static bool isPhone(String input) {
    RegExp mobile = RegExp(r'1[0-9]\d{9}$');
    return mobile.hasMatch(input);
  }

  //六位数字验证码
  static bool isValidateCaptcha(String input) {
    RegExp mobile = RegExp(r'\d{6}$');
    return mobile.hasMatch(input);
  }

  //验证数字
  static bool isNumber(String input) {
    RegExp mobile = RegExp(r'\d$');
    return mobile.hasMatch(input);
  }
}
