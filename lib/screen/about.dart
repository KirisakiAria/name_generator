//核心库
import 'package:flutter/material.dart';
//common
import '../common/style.dart';

class AboutPage extends StatelessWidget {
  @override
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
                      'V0.0.1',
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
