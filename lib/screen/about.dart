//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/style.dart';
import '../common/global.dart';
//model
import '../model/user.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '关于',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) => Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 30.h,
                ),
                alignment: Alignment.center,
                child: Image(
                  width: 120.w,
                  image: AssetImage('assets/images/pluto-searching.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 30.h,
                ),
                child: Text(
                  '彼岸自在',
                  style: TextStyle(
                    fontFamily: 'NijimiMincho',
                    fontSize: 30,
                    letterSpacing: 5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/webview', arguments: <String, String>{
                            'title': '隐私协议',
                            'url': 'http://192.168.50.83:8083/#/privacypolicy'
                          });
                        },
                        title: Text(
                          '隐私协议',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/webview',
                              arguments: <String, String>{
                                'title': '服务条款',
                                'url': 'http://192.168.50.83:8083/#/terms'
                              });
                        },
                        title: Text(
                          '服务条款',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/webview',
                              arguments: <String, String>{
                                'title': '使用方法',
                                'url': 'http://192.168.50.83:8083/#/usage'
                              });
                        },
                        title: Text(
                          '使用方法',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () async {
                          final String username = context.read<User>().username;
                          final String tel = context.read<User>().tel;
                          Navigator.pushNamed(context, '/webview',
                              arguments: <String, String>{
                                'title': '使用方法',
                                'url':
                                    'http://192.168.50.83:8083/#/feedback?tel=$tel&username=$username'
                              });
                        },
                        title: Text(
                          '意见反馈',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () async {
                          try {
                            launch('market://details?id=${Global.packageName}');
                          } catch (e) {
                            launch(
                                'https://play.google.com/store/apps/details?id=${Global.packageName}');
                          }
                        },
                        title: Text(
                          '给个好评',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () async {
                          try {
                            final String path = API.update;
                            final Response res =
                                await Request.init(context: context)
                                    .httpGet('$path?version=${Global.version}');
                            if (res.data['code'] == '1000') {
                              print(res.data['message']);
                              final SnackBar snackBar = SnackBar(
                                content: Text(res.data['message']),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          } catch (err) {
                            print(err);
                          }
                        },
                        title: Text(
                          '检查更新',
                          style: TextStyle(
                            height: 1,
                            color: Color(Style.grey20),
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
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
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10.h,
                      ),
                      child: Text(
                        '© 2020 伟大鱼塘 All Rights Reserved',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
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
