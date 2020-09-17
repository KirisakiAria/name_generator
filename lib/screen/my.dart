//核心库
import 'dart:async';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/custom_icon_data.dart';
import '../common/style.dart';
//model
import '../model/user.dart';
import '../model/skin.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<void> _loadData() async {
    final String path = API.getUserData;
    final Response res = await Request.init(context: context).httpPost(
      path,
      <String, String>{
        'tel': context.read<UserProvider>().tel,
      },
    );
    if (res.data['code'] == '1000') {
      final Map data = res.data['data'];
      context.read<UserProvider>().changeUserData(
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
      body: RefreshIndicator(
        color: Style.grey20,
        backgroundColor: Colors.white,
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
        top: 85.h,
        bottom: 40.h,
      ),
      decoration: BoxDecoration(
        color: context.watch<SkinProvider>().color['background'],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: context.watch<SkinProvider>().color['infoShadow'],
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          //未登录状态下点击会跳到登录页
          if (!context.read<UserProvider>().loginState) {
            Navigator.pushNamed(context, '/login');
          }
        },
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: ClipOval(
                  //透明图像占位符
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image:
                        '${API.origin}${context.watch<UserProvider>().avatar}',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 16.h,
                  bottom: 15.h,
                ),
                child: Text(
                  context.watch<UserProvider>().username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'UID: ${context.watch<UserProvider>().uid}',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.watch<SkinProvider>().color['subtitle'],
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 40.h,
      ),
      child: Wrap(
        spacing: 25,
        runSpacing: 32,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (!context.read<UserProvider>().loginState) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(context, '/favourites');
              }
            },
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.favourite,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '我的收藏',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!context.read<UserProvider>().loginState) {
                Navigator.pushNamed(context, '/login');
              } else {
                Navigator.pushNamed(context, '/history');
              }
            },
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.history,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '查询记录',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.setting,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '设置',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.about,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '关于',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //Navigator.pushNamed(context, '/laboratory');
              final SnackBar snackBar = SnackBar(
                content: const Text('暂未开放, 敬请期待'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.laboratory,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '实验室',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (context.read<UserProvider>().loginState) {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, anim1, anim2) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('提示'),
                      content: const Text('是否退出登录?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color:
                                  context.watch<SkinProvider>().color['text'],
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
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          onPressed: () async {
                            context.read<UserProvider>().logOut();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                      ],
                    );
                  },
                  barrierColor: Color.fromRGBO(0, 0, 0, .4),
                  barrierDismissible: false,
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
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.logout,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      '退出登录',
                      style: TextStyle(height: 2.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
