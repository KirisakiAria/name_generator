//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
//model
import '../model/user.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[BaseInformationBox(), Menu()],
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
          ]),
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
                      color: Colors.black87),
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
        }
      },
    ),
    CustomIcon(
      iconData: 0xe607,
      title: '查询记录',
      callback: (context) {
        if (!context.read<User>().loginState) {
          Navigator.pushNamed(context, '/login');
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
    ),
    CustomIcon(
      iconData: 0xe692,
      title: '实验室',
      callback: (context) {
        final SnackBar snackBar = SnackBar(content: Text('敬请期待'));
        Scaffold.of(context).showSnackBar(snackBar);
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
                    color: Color(0xFF212121),
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
