import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//provider
import './model/name_options.dart';
//全局数据
import './common/global.dart';
//路由
import './routes/routes.dart';
//首页
import './screen/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NameOptions()),
  ], child: MyApp()));
  if (Platform.isAndroid) {
    //沉浸式
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '网名生成器',
      home: HomePage(),
      routes: Routes.mappingList,
    );
  }
}
