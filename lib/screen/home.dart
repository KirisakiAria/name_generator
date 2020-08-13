//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//page
import '../screen/generate.dart';
import '../screen/my.dart';
//common
import '../common/style.dart';
import '../common/custom_icon_data.dart';
//model
import '../model/user.dart';

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

  //获取登陆状态
  _getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _token = prefs.getString('token');
    if (_token != null) {
      context.read<User>().changeUserData(
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
    _getLoginStatus();
    //_showPopup();
    return Scaffold(
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
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black38,
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
        selectedItemColor: Color(Style.mainColor),
      ),
    );
  }
}
