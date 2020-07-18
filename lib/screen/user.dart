//核心库
import 'package:flutter/material.dart';
//页面
import './login.dart';
import './register.dart';

class InheritedUserPage extends InheritedWidget {
  final bool showRegister;
  final void Function({bool show}) changeShowRegister;

  InheritedUserPage({
    Key key,
    @required this.showRegister,
    @required this.changeShowRegister,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedUserPage of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUserPage>();
  }

  @override
  bool updateShouldNotify(InheritedUserPage oldWidget) {
    return showRegister != oldWidget.showRegister;
  }
}

class InheritedUserPageContainer extends StatefulWidget {
  @override
  _InheritedUserPageState createState() => _InheritedUserPageState();
}

class _InheritedUserPageState extends State<InheritedUserPageContainer> {
  bool showRegister = false;
  int count = 0;

  changeShowRegister({bool show}) {
    setState(() {
      showRegister = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      //当child发生变化时（类型或key不同），旧child执行隐藏动画，新child执行显示动画
      duration: Duration(milliseconds: 450),
      transitionBuilder: (Widget child, Animation<double> animation) {
        Tween<Offset> tween =
            Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        return FadeTransition(
            opacity: animation,
            child: MySlideTransition(
              child: child,
              position: tween.animate(animation),
            ));
      },
      child: InheritedUserPage(
        key: ValueKey<bool>(showRegister),
        showRegister: showRegister,
        child: _UserPage(),
        changeShowRegister: ({bool show}) => changeShowRegister(show: show),
      ),
    );
  }
}

class _UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showRegister = InheritedUserPage.of(context).showRegister;
    if (showRegister) {
      return RegisterPage();
    }
    return LoginPage();
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
