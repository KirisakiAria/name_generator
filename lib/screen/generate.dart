//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
//model
import '../model/word_options.dart';
import '../model/user.dart';
import '../model/skin.dart';

class GeneratePage extends StatefulWidget {
  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage>
    with AutomaticKeepAliveClientMixin {
  String _word = '彼岸自在';
  String _type = '中国风';

  Future<void> _getData() async {
    try {
      final String path = API.word;
      final Response res = await Request.init(context: context).httpPost(
        path,
        <String, dynamic>{
          'type': context.read<WordOptionsProvider>().type,
          'length': context.read<WordOptionsProvider>().length,
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          _word = res.data['data']['word'];
          _type = context.read<WordOptionsProvider>().type;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  //服务条款和隐私协议弹窗
  _showPopup() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async => Future.value(false),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('服务条款与隐私协议提示'),
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: context.watch<SkinProvider>().color['text'],
                ),
                children: <TextSpan>[
                  TextSpan(text: '我们根据相关法律法规制定了'),
                  TextSpan(
                    text: '隐私协议',
                    style: TextStyle(color: Colors.lightBlue),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          '/webview',
                          arguments: <String, String>{
                            'title': '隐私协议',
                            'url': 'http://192.168.50.83:8083/#/privacypolicy'
                          },
                        );
                      },
                  ),
                  TextSpan(text: '和'),
                  TextSpan(
                    text: '服务条款',
                    style: TextStyle(color: Colors.lightBlue),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/webview',
                            arguments: <String, String>{
                              'title': '服务条款',
                              'url': 'http://192.168.50.83:8083/#/terms'
                            });
                      },
                  ),
                  TextSpan(
                    text:
                        '建议您认真阅读这些条款。您同意之后便可以正常使用《彼岸自在》提供的服务，若您拒绝，则无法使用《彼岸自在》并退出应用程序。',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '拒绝',
                  style: TextStyle(
                    color: context.watch<SkinProvider>().color['text'],
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
              FlatButton(
                child: Text(
                  '同意',
                  style: TextStyle(
                    color: context.watch<SkinProvider>().color['text'],
                    fontSize: 16,
                  ),
                ),
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('accepted', true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    //绘制完最后一帧时回调，并且只调用一次。类似于Vue里的mounted钩子
    widgetsBinding.addPostFrameCallback((callback) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final dynamic accepted = prefs.getBool('accepted');
      if (accepted == null) {
        _showPopup();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Display(
              word: _word,
              type: _type,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomButton(
                  text: '生成',
                  bgColor: context.watch<SkinProvider>().color['button'],
                  textColor: context.watch<SkinProvider>().color['background'],
                  borderColor: Style.defaultColor['button'],
                  callback: () {
                    _getData();
                  },
                ),
                CustomButton(
                  text: '選項',
                  bgColor: Style.defaultColor['background'],
                  textColor: Style.defaultColor['button'],
                  borderColor: Style.defaultColor['button'],
                  callback: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return OptionsDialog();
                      },
                      barrierColor: Colors.grey.withOpacity(.4),
                      barrierDismissible: false,
                      transitionDuration: Duration(milliseconds: 400),
                      transitionBuilder: (context, anim1, anim2, child) {
                        final double curvedValue =
                            Curves.easeInOutBack.transform(anim1.value) - 1;
                        return Transform(
                          transform: Matrix4.translationValues(
                            0,
                            curvedValue * -320,
                            0,
                          ),
                          child: OptionsDialog(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 25.h,
            ),
            child: Text(
              '提示：单击文字复制，长按加收藏',
              style: TextStyle(
                color: context.watch<SkinProvider>().color['subtitle'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Display extends StatefulWidget {
  final String word;
  final String type;
  Display({
    @required this.word,
    @required this.type,
  });

  @override
  _DisplayState createState() => _DisplayState();
}

//图片/文字显示区域
class _DisplayState extends State<Display> with SingleTickerProviderStateMixin {
  Duration _duration = Duration(milliseconds: 500);
  AnimationController _controller;
  Animation<double> _opacityAnimation, _sizeAnimation;
  static final _opacityTween = new Tween<double>(begin: 1.0, end: 0.0);
  static final _sizeTween = new Tween<double>(begin: 0.0, end: 120.0);

  Future<void> _love() async {
    try {
      final String path = API.favourite;
      await Request.init(context: context).httpPost(
        path,
        <String, dynamic>{
          'type': context.read<WordOptionsProvider>().type,
          'length': context.read<WordOptionsProvider>().length,
          'word': widget.word,
        },
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // 用于实时更新_animation.value
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 监听动画完成的状态
          _controller.reset();
        }
      });
    CurvedAnimation curvedanimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _sizeAnimation = _sizeTween.animate(curvedanimation);
    _opacityAnimation = _opacityTween.animate(curvedanimation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 10.h,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Icon(
              Icons.favorite,
              size: _sizeAnimation.value,
              color: Color(0xffff6b81),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 5.h,
              ),
              child: Image(
                image: AssetImage('assets/images/pluto-payment-processed.png'),
                width: 180.w,
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.word));
                final SnackBar snackBar = SnackBar(
                  content: Text('复制成功'),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              },
              onLongPress: () {
                final bool loginState = context.read<UserProvider>().loginState;
                if (loginState) {
                  _love();
                  _controller.forward();
                } else {
                  final SnackBar snackBar = SnackBar(
                    content: Text('请先登录再加收藏'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: 50.h,
                ),
                child: Text(
                  widget.word,
                  style: TextStyle(
                    fontFamily: widget.type == '中国风' ? '' : 'NijimiMincho',
                    fontSize: 54,
                    letterSpacing: 12,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//自定义的select
class InheritedSelect extends InheritedWidget {
  //options列表
  final List<String> list;
  //选择之后回调
  final void Function(String newValue) callback;
  //当前值
  final dynamic currentValue;

  InheritedSelect({
    Key key,
    @required this.list,
    @required this.callback,
    @required this.currentValue,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedSelect of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedSelect>();
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(InheritedSelect oldWidget) {
    return list != oldWidget.list;
  }
}

class SelectBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedSelect.of(context);
    return Container(
      width: 165.w,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: context.watch<SkinProvider>().color['text'],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      child: Select(inheritedContext.currentValue),
    );
  }
}

class Select extends StatefulWidget {
  final String dropdownValue;

  Select(this.dropdownValue);

  @override
  _SelectState createState() => _SelectState(dropdownValue);
}

class _SelectState extends State<Select> {
  String dropdownValue;

  _SelectState(this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedSelect.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isDense: true,
        value: dropdownValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: context.watch<SkinProvider>().color['text'],
        ),
        iconSize: 18,
        elevation: 0,
        isExpanded: true,
        style: TextStyle(
          color: context.watch<SkinProvider>().color['text'],
          fontSize: 20,
          height: 1.1,
        ),
        onChanged: (dynamic newValue) {
          setState(() {
            dropdownValue = newValue;
            inheritedContext.callback(newValue);
          });
        },
        dropdownColor: context.watch<SkinProvider>().color['background'],
        items:
            inheritedContext.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class OptionsDialog extends Dialog {
  OptionsDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 320.h,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: context.watch<SkinProvider>().color['widget'],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Text(
                    '选项',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InheritedSelect(
                  list: OptionsData.typeList,
                  callback: (newValue) {
                    context
                        .read<WordOptionsProvider>()
                        .changeType(type: newValue);
                  },
                  currentValue: context.watch<WordOptionsProvider>().type,
                  child: SelectBox(),
                ),
                InheritedSelect(
                  list: OptionsData.lengthList,
                  callback: (newValue) {
                    context
                        .read<WordOptionsProvider>()
                        .changeNumber(length: newValue);
                  },
                  currentValue: context.watch<WordOptionsProvider>().length,
                  child: SelectBox(),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 80.w,
                  ),
                  child: CustomButton(
                    text: '確定',
                    bgColor: context.watch<SkinProvider>().color['button'],
                    textColor:
                        context.watch<SkinProvider>().color['background'],
                    borderColor: Style.defaultColor['button'],
                    callback: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
