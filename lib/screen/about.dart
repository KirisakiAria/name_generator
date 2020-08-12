//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:shared_preferences/shared_preferences.dart';
//common
import '../common/style.dart';
import '../common/global.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '关于',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Image(
                width: 150,
                image: AssetImage('assets/images/pluto-searching.png'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
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
                padding: EdgeInsets.only(left: 10),
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/webview',
                            arguments: <String, String>{
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
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String username = prefs.getString('username');
                        final String tel = prefs.getString('tel');
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
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 20),
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
                    margin: EdgeInsets.only(top: 10),
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
    );
  }
}
