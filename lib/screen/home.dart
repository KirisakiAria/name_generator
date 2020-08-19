//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  _getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int themeIndex = prefs.getInt('themeIndex');
    if (themeIndex != null) {
      context.read<SkinProvider>().changeTheme(
            theme: Style.themeList[themeIndex],
            color: Style.colorList[themeIndex],
          );
    }
  }

  //获取登陆状态
  _getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      context.read<UserProvider>().changeUserData(
            username: prefs.getString('username'),
            tel: prefs.getString('tel'),
            uid: prefs.getInt('uid'),
            avatar: prefs.getString('avatar'),
            date: prefs.getString('date'),
            token: prefs.getString('token'),
            loginState: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: 375,
      height: 900,
    );
    _getTheme();
    _getLoginStatus();
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
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                const IconData(
                  CustomIconData.cat,
                  fontFamily: 'iconfont',
                ),
                size: 28,
              ),
              title: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
