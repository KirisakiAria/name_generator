import 'package:package_info/package_info.dart';

class Global {
  static String appName; //应用名称
  static String packageName; //包名称
  static String version; //版本号
  static String buildNumber; //小版本号

  static Future init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
