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
                blurRadius: 12.0,
                offset: Offset(0, 6.0)),
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
                  color: Color(0xFF333333)),
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
