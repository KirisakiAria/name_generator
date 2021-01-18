//核心库
import 'dart:async';
import 'package:bianzizai/model/word_options.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//common
import '../../common/custom_icon_data.dart';
import '../../common/style.dart';
import '../../common/word_options.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';
import '../../model/laboratory_options.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<void> _getUserData() async {
    try {
      final String path = API.getUserData;
      final Response res = await Request(
        context: context,
      ).httpPost(
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
              vip: data['vip'],
              vipStartTime: data['vipStartTime'],
              vipEndTime: data['vipEndTime'],
              avatar: data['avatar'],
              date: data['date'],
              loginState: true,
            );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(
              context,
              '/notifications',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Style.grey20,
        backgroundColor: Colors.white,
        onRefresh: _getUserData,
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
        bottom: 32.h,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        color: context.watch<SkinProvider>().color['background'],
        shadows: [
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
          final bool loginState = context.read<UserProvider>().loginState;
          if (!loginState) {
            Navigator.pushNamed(
              context,
              '/login',
            );
          } else {
            Navigator.pushNamed(
              context,
              '/account',
            );
          }
        },
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 70.w,
                height: 70.w,
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
                margin: EdgeInsets.only(
                  top: 16.h,
                ),
                child: Text(
                  context.watch<UserProvider>().username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 12.h,
                ),
                child: Text(
                  'UID: ${context.watch<UserProvider>().uid}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.watch<SkinProvider>().color['subtitle'],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 12.h,
                ),
                child: Builder(
                  builder: (BuildContext context) {
                    final vip = context.watch<UserProvider>().vip;
                    if (vip) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image:
                                AssetImage('assets/images/vip/vip_budge.png'),
                            width: 20.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                            ),
                            child: const Text(
                              'VIP会员',
                              style: TextStyle(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(
                                'assets/images/vip/vip_budge_grey.png'),
                            width: 20.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 5,
                            ),
                            child: const Text(
                              '未开通',
                              style: TextStyle(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
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
        vertical: 52.h,
      ),
      child: Wrap(
        spacing: 25,
        runSpacing: 30,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              final bool loginState = context.read<UserProvider>().loginState;
              if (!loginState) {
                final SnackBar snackBar = SnackBar(
                  content: const Text('请先登录再使用此菜单'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushNamed(
                  context,
                  '/webview',
                  arguments: <String, String>{
                    'title': '使用方法',
                    'url': '${API.host}/#/usage',
                  },
                );
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
                        padding: EdgeInsets.all(
                          15.w,
                        ),
                        color: context.watch<SkinProvider>().color['widget'],
                        child: Icon(
                          const IconData(
                            CustomIconData.book,
                            fontFamily: 'iconfont',
                          ),
                          color: context.watch<SkinProvider>().color['text'],
                          size: 30,
                        ),
                      ),
                    ),
                    const Text(
                      '使用教程',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final bool loginState = context.read<UserProvider>().loginState;
              if (!loginState) {
                final SnackBar snackBar = SnackBar(
                  content: const Text('请先登录再使用此菜单'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushNamed(
                  context,
                  '/favourites',
                );
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
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
                      '我的收藏',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final bool loginState = context.read<UserProvider>().loginState;
              if (!loginState) {
                final SnackBar snackBar = SnackBar(
                  content: const Text('请先登录再使用此菜单'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushNamed(
                  context,
                  '/history',
                );
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
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
                      '查询记录',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/setting',
            ),
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
                      '设置',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/about',
            ),
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
                      '关于',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/laboratory',
            ),
            child: Container(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
                      '实验室',
                      style: TextStyle(
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final bool loginState = context.read<UserProvider>().loginState;
              if (loginState) {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> anim1,
                    Animation<double> anim2,
                  ) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('提示'),
                      content: const Text('是否退出登录？'),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(
                            '确认',
                            style: TextStyle(
                              color:
                                  context.watch<SkinProvider>().color['text'],
                            ),
                          ),
                          onPressed: () async {
                            try {
                              Navigator.pop(context);
                              context.read<UserProvider>().logOut();
                              context
                                  .read<WordOptionsProvider>()
                                  .changeType(WordOptions.typeList[0]);
                              context
                                  .read<WordOptionsProvider>()
                                  .changeNumber(WordOptions.lengthList[1]);
                              context
                                  .read<WordOptionsProvider>()
                                  .changeCouples(false);
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              context
                                  .read<LaboratoryOptionsProvider>()
                                  .clearAllSetting();
                              Navigator.pushNamed(
                                context,
                                '/login',
                              );
                            } catch (err) {
                              print(err);
                            }
                          },
                        ),
                      ],
                    );
                  },
                  barrierColor: Color.fromRGBO(0, 0, 0, .4),
                  transitionDuration: Duration(milliseconds: 200),
                  transitionBuilder: (
                    BuildContext context,
                    Animation<double> anim1,
                    Animation<double> anim2,
                    Widget child,
                  ) {
                    return Transform.scale(
                      scale: anim1.value,
                      child: child,
                    );
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  '/login',
                );
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
                        padding: EdgeInsets.all(
                          15.w,
                        ),
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
                    const Text(
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
