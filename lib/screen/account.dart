//核心库
import 'dart:io';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
//请求
import '../services/api.dart';
//model
import '../model/user.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '设置',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      //context必须是Scaffold的子context，Scaffold.of才能生效
      body: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '头像',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: ClipOval(
                          //透明图像占位符
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image:
                                  '${API.origin}${context.watch<User>().avatar}'),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '用户名',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          '${context.watch<User>().username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '性别',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          '${context.watch<User>().username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
