//核心库
import 'package:flutter/material.dart';
//页面
import './login.dart';
import './register.dart';
import './change_password.dart';

class InheritedUserPage extends InheritedWidget {
  final int screenIndex;
  final void Function({@required int index}) changeScreen;

  InheritedUserPage({
    Key key,
    @required this.screenIndex,
    @required this.changeScreen,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedUserPage of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUserPage>();
  }

  @override
  bool updateShouldNotify(InheritedUserPage oldWidget) {
    return screenIndex != oldWidget.screenIndex;
  }
}

class InheritedUserPageContainer extends StatefulWidget {
  @override
  _InheritedUserPageState createState() => _InheritedUserPageState();
}

class _InheritedUserPageState extends State<InheritedUserPageContainer> {
  //1登录 2注册 3修改密码
  int screenIndex = 1;

  void changeScreen({@required int index}) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      //当child发生变化时（类型或key不同），旧child执行隐藏动画，新child执行显示动画
      duration: Duration(milliseconds: 450),
      transitionBuilder: (Widget child, Animation<double> animation) {
        Tween<Offset> tween = Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        );
        return FadeTransition(
          opacity: animation,
          child: MySlideTransition(
            child: child,
            position: tween.animate(animation),
          ),
        );
      },
      child: InheritedUserPage(
        key: ValueKey<int>(screenIndex),
        screenIndex: screenIndex,
        child: _UserPage(),
        changeScreen: ({@required int index}) => changeScreen(index: index),
      ),
    );
  }
}

class _UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenIndex = InheritedUserPage.of(context).screenIndex;
    if (screenIndex == 1) {
      return LoginPage();
    } else if (screenIndex == 2) {
      return RegisterPage();
    }
    return ChangePasswordPage();
  }
}

class MySlideTransition extends AnimatedWidget {
  MySlideTransition({
    Key key,
    @required Animation<Offset> position,
    this.transformHitTests = true,
    this.child,
  })  : assert(position != null),
        super(key: key, listenable: position);

  Animation<Offset> get position => listenable;
  final bool transformHitTests;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Offset offset = position.value;
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
