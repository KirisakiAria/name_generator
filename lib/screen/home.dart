import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//page
import 'package:namegenerator/screen/login.dart';
import 'package:namegenerator/screen/generate.dart';
import 'package:namegenerator/screen/my.dart';
//common
import '../common/style.dart';
//model
import '../model/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _tabIndex = 0;

  _onPageChange(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<User>().loginState) {
      return LoginPage();
    }
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
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 400), curve: Curves.ease);
          },
          currentIndex: _tabIndex,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black38,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(IconData(0xe6ac, fontFamily: 'iconfont'), size: 28),
              title: Container(),
            ),
            BottomNavigationBarItem(
              icon: Icon(IconData(0xe65e, fontFamily: 'iconfont'), size: 28),
              title: Container(),
            ),
          ],
          selectedItemColor: Color(Style.mainColor),
        ));
  }
}
