//核心库
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
//model
import '../model/name_options.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[BaseInformationBox(), Menu()],
      ),
    );
  }
}

class BaseInformationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 80, 180, 0.1),
                blurRadius: 12,
                offset: Offset(0, 6)),
          ]),
      child: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: ClipOval(
                child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage('http://localhost:8080/avatar.jpg'))),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: Text(
              '空洞共鳴',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Container(
            child: Text(
              '啊这',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )
        ],
      )),
    );
  }
}

class Menu extends StatelessWidget {
  final List<Widget> iconlist = <Widget>[
    CustomIcon(
      iconData: 0xe607,
      title: '历史记录',
    ),
    CustomIcon(
      iconData: 0xe654,
      title: '设置',
    ),
    CustomIcon(
      iconData: 0xe617,
      title: '关于',
    ),
    CustomIcon(
      iconData: 0xe692,
      title: '实验室',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Wrap(
        spacing: 35,
        runSpacing: 30,
        children: iconlist,
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final int iconData;
  final String title;

  CustomIcon({this.iconData, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
              child: Container(
            padding: EdgeInsets.all(15),
            color: Color(0xFFf5f5f5),
            child: Icon(IconData(iconData, fontFamily: 'iconfont'),
                color: Color(0xFF212121), size: 32),
          )),
          Text(
            title,
            style: TextStyle(fontSize: 12, height: 2.5),
          )
        ],
      ),
    ));
  }
}
