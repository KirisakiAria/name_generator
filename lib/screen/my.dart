//核心库
import 'dart:async';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/style.dart';
//model
import '../model/user.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<void> _loadData() async {
    final String path = API.getUserData;
    final Response res = await Request.init(context).httpPost(
      path,
      <String, String>{
        'tel': context.read<User>().tel,
      },
    );
    if (res.data['code'] == '1000') {
      final Map data = res.data['data'];
      context.read<User>().changeUserData(
            username: data['username'],
            tel: data['tel'],
            uid: data['uid'],
            avatar: data['avatar'],
            date: data['date'],
            token: data['token'],
            loginState: true,
          );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', data['username']);
      prefs.setString('tel', data['tel']);
      prefs.setInt('uid', data['uid']);
      prefs.setString('avatar', data['avatar']);
      prefs.setString('date', data['date']);
      prefs.setString('token', data['token']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              BaseInformationBox(),
              Menu(),
            ],
          ),
        ),
      ),
    );
  }
}

//个人信息显示区域
class BaseInformationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 100,
        bottom: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 80, 180, 0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          //未登录状态下点击会跳到登录页
          if (!context.read<User>().loginState) {
            Navigator.pushNamed(context, '/login');
          }
        },
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 80,
                child: ClipOval(
                  //透明图像占位符
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: '${API.origin}${context.watch<User>().avatar}',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 5,
                ),
                child: Text(
                  context.watch<User>().username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'UID: ${context.watch<User>().uid}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//菜单列表
class Menu extends StatelessWidget {
  final List<Widget> iconlist = <Widget>[
    CustomIcon(
      iconData: 0xe666,
      title: '我的收藏',
      callback: (context) {
        if (!context.read<User>().loginState) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(context, '/favourites');
        }
      },
    ),
    CustomIcon(
      iconData: 0xe607,
      title: '查询记录',
      callback: (context) {
        if (!context.read<User>().loginState) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(context, '/history');
        }
      },
    ),
    CustomIcon(
      iconData: 0xe654,
      title: '设置',
      callback: (context) {
        Navigator.pushNamed(context, '/setting');
      },
    ),
    CustomIcon(
      iconData: 0xe617,
      title: '关于',
      callback: (context) {
        Navigator.pushNamed(context, '/about');
      },
    ),
    CustomIcon(
      iconData: 0xe692,
      title: '实验室',
      callback: (context) {
        final SnackBar snackBar = SnackBar(
          content: Text('暂未开放, 敬请期待'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
    ),
    CustomIcon(
      iconData: 0xe60d,
      title: '退出登录',
      callback: (context) {
        if (context.read<User>().loginState) {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('提示'),
                content: Text('是否退出登录?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Color(Style.mainColor),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      '确认',
                      style: TextStyle(
                        color: Color(Style.mainColor),
                      ),
                    ),
                    onPressed: () async {
                      context.read<User>().logOut();
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              );
            },
            barrierDismissible: false,
            barrierLabel: '',
            transitionDuration: Duration(milliseconds: 200),
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: child,
              );
            },
          );
        } else {
          Navigator.pushNamed(context, '/login');
        }
      },
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
  final void Function(BuildContext context) callback;

  CustomIcon({
    @required this.iconData,
    @required this.title,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(context);
      },
      child: Container(
        child: SizedBox(
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: Color(0xFFf5f5f5),
                  child: Icon(
                    IconData(
                      iconData,
                      fontFamily: 'iconfont',
                    ),
                    size: 32,
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(height: 2.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
