import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//第三方库
import 'package:device_info/device_info.dart';
//请求
import './services/api.dart';
import './services/request.dart';
//model
import './model/word_options.dart';
import './model/user.dart';
//commom
import './common/global.dart';
import './common/style.dart';
//路由
import './routes/routes.dart';
//首页
import './screen/home.dart';

Future<Null> main() async {
  //错误信息收集
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Global.init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WordOptions>(
            create: (_) => WordOptions(),
          ),
          ChangeNotifierProvider<User>(
            create: (_) => User(),
          ),
        ],
        child: MyApp(),
      ),
    );
    if (Platform.isAndroid) {
      //沉浸式
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }, onError: (error, stackTrace) async {
    _reportError(error, stackTrace);
  });
}

//错误信息收集
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String brand, systemVersion, system;
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    brand = androidInfo.brand;
    systemVersion = androidInfo.version.release;
    system = 'android';
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    brand = 'apple';
    systemVersion = iosInfo.systemVersion;
    system = 'ios';
  }
  final String path = API.error;
  await Request.init(context: null).httpPost(
    path,
    <String, dynamic>{
      'appVersion': Global.version,
      'brand': brand,
      'system': system,
      'systemVersion': systemVersion,
      'error': error.toString(),
      'stackTrace': stackTrace.toString()
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '网名生成器',
      home: HomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        primaryColor: Color(Style.mainColor),
        accentColor: Color(Style.mainColor),
      ),
      routes: Routes.mappingList,
    );
  }
}
