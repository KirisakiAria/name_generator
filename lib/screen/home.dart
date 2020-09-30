//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//page
import '../screen/generate.dart';
import '../screen/my.dart';
//common
import '../common/style.dart';
import '../common/custom_icon_data.dart';
//model
import '../model/user.dart';
import '../model/skin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _tabIndex = 0;

  //PageView页面滚动事件回调
  _onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  //设置主题
  Future<void> _getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int themeIndex = prefs.getInt('themeIndex');
    if (themeIndex != null) {
      context.read<SkinProvider>().changeTheme(
            themeIndex: themeIndex,
            theme: Style.themeList[themeIndex],
            color: Style.colorList[themeIndex],
          );
    }
  }

  //获取登陆状态
  Future<void> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final dynamic token = prefs.getString('token');
    final dynamic tel = prefs.getString('tel');
    if (token != null) {
      context.read<UserProvider>().changeToken(token);
      final String path = API.getUserData;
      final Response res = await Request.init(
        context: context,
        showLoadingDialog: false,
      ).httpPost(
        path,
        <String, String>{
          'tel': tel,
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
              loginState: true,
            );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    //绘制完最后一帧时回调，并且只调用一次。类似于Vue里的mounted钩子
    widgetsBinding.addPostFrameCallback((callback) async {
      _getTheme();
      _getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: 375,
      height: 900,
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView.builder(
          onPageChanged: _onPageChange,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GeneratePage();
            }
            return MyPage();
          },
          itemCount: 2,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: _tabIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                const IconData(
                  CustomIconData.generate,
                  fontFamily: 'iconfont',
                ),
                size: 28,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                const IconData(
                  CustomIconData.cat,
                  fontFamily: 'iconfont',
                ),
                size: 28,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
