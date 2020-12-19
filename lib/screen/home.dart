//核心库
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//page
import '../screen/generate/generate.dart';
import '../screen/search/search.dart';
import '../screen/inspiration/inspiration.dart';
import '../screen/my/my.dart';
//common
import '../common/style.dart';
import '../common/custom_icon_data.dart';
//model
import '../model/user.dart';
import '../model/skin.dart';
import '../model/laboratory_options.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final FocusNode blankNode = FocusNode();
  int _tabIndex = 0;

  //PageView页面滚动事件回调
  _onPageChange(int index) {
    FocusScope.of(context).requestFocus(blankNode);
    setState(() {
      _tabIndex = index;
    });
  }

  //设置主题
  Future<void> _getTheme() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int themeIndex = prefs.getInt('themeIndex');
      if (themeIndex != null) {
        context.read<SkinProvider>().changeTheme(
              themeIndex: themeIndex,
              theme: Style.themeList[themeIndex],
              color: Style.colorList[themeIndex],
            );
      }
    } catch (err) {
      print(err);
    }
  }

  //获取登陆状态
  Future<void> _getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final dynamic token = prefs.getString('token');
      final dynamic tel = prefs.getString('tel');
      if (token != null) {
        context.read<UserProvider>().changeToken(token);
        final String path = API.getUserData;
        final Response res = await Request(
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
                vip: data['vip'],
                vipStartTime: data['vipStartTime'],
                vipEndTime: data['vipEndTime'],
                avatar: data['avatar'],
                date: data['date'],
                loginState: true,
              );
          _initSetting();
        }
      }
    } catch (err) {
      print(err);
    }
  }

  //读取并初始化本地配置
  Future<void> _initSetting() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool romaji = prefs.getBool('romaji') ?? false;
      context.read<LaboratoryOptionsProvider>().toggleRomaji(romaji: romaji);
    } catch (err) {
      print(err);
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 退出APP标记
  bool isQuit = false;
  // 清除标记定时器
  Timer quitTimer;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 可以返回
        if (!Navigator.canPop(context)) {
          // 检查退出标记
          if (isQuit) {
            // 退出APP
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          } else {
            final SnackBar snackBar = SnackBar(
              content: Text('再按一次退出APP'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // 记录退出标记
            isQuit = true;
            // 开启定时器，两秒后清除标记
            quitTimer = Timer(Duration(seconds: 2), () {
              isQuit = false;
              quitTimer.cancel();
            });
          }
          // 阻止返回
          return false;
        }
        isQuit = false;
        // 默认正常运行
        return true;
      },
      child: Scaffold(
        body: PageView.builder(
          onPageChanged: _onPageChange,
          controller: _pageController,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            if (index == 0) {
              return GeneratePage();
            } else if (index == 1) {
              return SearchPage();
            } else if (index == 2) {
              return InspirationPage();
            } else {
              return MyPage();
            }
          },
          itemCount: 4,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor:
                  context.watch<SkinProvider>().color['background'],
              icon: const Icon(
                const IconData(
                  CustomIconData.generate,
                  fontFamily: 'iconfont',
                ),
                size: 26,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  context.watch<SkinProvider>().color['background'],
              icon: const Icon(
                const IconData(
                  CustomIconData.search,
                  fontFamily: 'iconfont',
                ),
                size: 26,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  context.watch<SkinProvider>().color['background'],
              icon: const Icon(
                const IconData(
                  CustomIconData.inspiration,
                  fontFamily: 'iconfont',
                ),
                size: 26,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  context.watch<SkinProvider>().color['background'],
              icon: const Icon(
                const IconData(
                  CustomIconData.cat,
                  fontFamily: 'iconfont',
                ),
                size: 26,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
