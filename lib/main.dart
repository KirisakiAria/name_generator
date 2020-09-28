import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
//model
import './model/word_options.dart';
import './model/user.dart';
import './model/skin.dart';
//commom
import './common/global.dart';
//路由
import './routes/routes.dart';
//首页
import './screen/home.dart';

//解决https证书不通过的问题。因为图片不是通过dio加载的，所以需要处理原本的http组件
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  HttpOverrides.global = new MyHttpOverrides();
  //runZoned类似于沙箱，沙箱可以捕获、拦截或修改一些代码行为
  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Global.init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<WordOptionsProvider>(
            create: (_) => WordOptionsProvider(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider<SkinProvider>(
            create: (_) => SkinProvider(),
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
    print(error);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '网名生成器',
      home: HomePage(),
      theme: context.watch<SkinProvider>().theme,
      routes: Routes.mappingList,
    );
  }
}
