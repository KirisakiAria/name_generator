import 'package:package_info/package_info.dart';

class Global {
  static String packageName; //包名称
  static String version; //版本号
  static String buildNumber; //小版本号

  static Future<void> init() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    } catch (err) {
      print(err);
    }
  }
}
