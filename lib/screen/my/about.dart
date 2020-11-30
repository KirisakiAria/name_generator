//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//common
import '../../common/global.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '关于',
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 20.h,
                ),
                alignment: Alignment.center,
                child: Image(
                  width: 130.w,
                  image: AssetImage('assets/images/about/about.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 30.h,
                ),
                child: const Text(
                  '彼岸自在',
                  style: TextStyle(
                    fontSize: 34,
                    letterSpacing: 5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: ListTileTheme(
                    iconColor: context.watch<SkinProvider>().color['subtitle'],
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/webview',
                            arguments: <String, String>{
                              'title': '隐私协议',
                              'url': '${API.host}/#/privacypolicy',
                            },
                          ),
                          title: Text(
                            '隐私协议',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/webview',
                            arguments: <String, String>{
                              'title': '服务条款',
                              'url': '${API.host}/#/terms',
                            },
                          ),
                          title: Text(
                            '服务条款',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/webview',
                            arguments: <String, String>{
                              'title': '使用方法',
                              'url': '${API.host}/#/usage',
                            },
                          ),
                          title: Text(
                            '使用方法',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/webview',
                            arguments: <String, String>{
                              'title': '更新日志',
                              'url': '${API.host}/#/update',
                            },
                          ),
                          title: Text(
                            '更新日志',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/webview',
                            arguments: <String, String>{
                              'title': '会员须知',
                              'url': '${API.host}/#/vip',
                            },
                          ),
                          title: Text(
                            '会员须知',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            final String username =
                                context.read<UserProvider>().username;
                            final String tel = context.read<UserProvider>().tel;
                            Navigator.pushNamed(
                              context,
                              '/webview',
                              arguments: <String, String>{
                                'title': '意见反馈',
                                'url':
                                    '${API.host}/#/feedback?tel=$tel&username=$username'
                              },
                            );
                          },
                          title: Text(
                            '意见反馈',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            try {
                              launch(
                                  'market://details?id=${Global.packageName}');
                            } catch (e) {
                              launch(
                                  'https://play.google.com/store/apps/details?id=${Global.packageName}');
                            }
                          },
                          title: Text(
                            '给个好评',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            try {
                              final String path = API.update;
                              final Response res = await Request(
                                context: context,
                              ).httpGet('$path?version=${Global.version}');
                              if (res.data['code'] == '1000') {
                                final SnackBar snackBar = SnackBar(
                                  content: Text(res.data['message']),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } catch (err) {
                              print(err);
                            }
                          },
                          title: Text(
                            '检查更新',
                            style: TextStyle(
                              height: 1,
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 50.h,
                  bottom: 20.h,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'V ${Global.version}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.h,
                      ),
                      child: const Text(
                        '© 2020 彼岸自在 All Rights Reserved',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
