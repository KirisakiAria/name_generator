//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//组件
import '../../widgets/custom_button.dart';
import '../../widgets/vip_tips_dialog.dart';
//common
import '../../common/style.dart';
import '../../common/optionsData.dart';
import '../../common/custom_icon_data.dart';
//model
import '../../model/word_options.dart';
import '../../model/user.dart';
import '../../model/skin.dart';
import '../../model/laboratory_options.dart';
//utils
import '../../utils/Utils.dart';
import '../../utils/floating_action_button.dart';
import '../../utils/explanation.dart';

class GeneratePage extends StatefulWidget {
  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage>
    with AutomaticKeepAliveClientMixin {
  static const String shareContent = '【彼岸自在，最懂你的网名生成器】';
  String _word = '彼岸自在';
  String _word2 = '吾溪不归';
  String _type = '中国风';
  String _romaji = 'Higanjizai';

  Future<void> _getData() async {
    try {
      final String path = API.word;
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'type': context.read<WordOptionsProvider>().type,
          'length': context.read<WordOptionsProvider>().length,
          'ifRomaji': context.read<LaboratoryOptionsProvider>().romaji,
          'couples': context.read<WordOptionsProvider>().couples,
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          _word = res.data['data']['word'];
          _word2 = res.data['data']['word2'];
          _type = context.read<WordOptionsProvider>().type;
          _romaji = res.data['data']['romaji'];
        });
      } else if (res.data['code'] == '3010') {
        context.read<WordOptionsProvider>().changeCouples(false);
        context.read<WordOptionsProvider>().changeNumber('2');
        context.read<UserProvider>().changeVip(false);
      }
    } catch (err) {
      print(err);
    }
  }

  //服务条款和隐私协议弹窗
  void _showAgreementPopup() {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return WillPopScope(
          //阻止返回键返回
          onWillPop: () async => Future.value(false),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('服务条款与隐私协议提示'),
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
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          '/webview',
                          arguments: <String, String>{
                            'title': '隐私协议',
                            'url': '${API.host}/#/privacypolicy'
                          },
                        );
                      },
                  ),
                  TextSpan(text: '和'),
                  TextSpan(
                    text: '服务条款',
                    style: TextStyle(color: Colors.lightBlue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          '/webview',
                          arguments: <String, String>{
                            'title': '服务条款',
                            'url': '${API.host}/#/terms'
                          },
                        );
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
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
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
                  try {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('accepted', true);
                    Navigator.pop(context);
                  } catch (err) {
                    print(err);
                  }
                },
              ),
            ],
          ),
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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    //绘制完最后一帧时回调，并且只调用一次。类似于Vue里的mounted钩子
    widgetsBinding.addPostFrameCallback((callback) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final dynamic accepted = prefs.getBool('accepted');
      accepted ?? _showAgreementPopup();
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(
              context,
              '/notifications',
            ),
          ),
          PopupMenuButton<String>(
            color: context.watch<SkinProvider>().color['background'],
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(Icons.share),
                    const Text('分享'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(Icons.info),
                    const Text('关于'),
                  ],
                ),
              ),
            ],
            onSelected: (String action) {
              // 点击选项的时候
              switch (action) {
                case 'share':
                  Share.share('$shareContent 官网：${API.host}');
                  break;
                case 'about':
                  Navigator.pushNamed(
                    context,
                    '/about',
                  );
                  break;
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: const Icon(
            const IconData(
              CustomIconData.dictionary,
              fontFamily: 'iconfont',
            ),
            color: Colors.white,
          ),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xff0093E9),
                Color(0xff80D0C7),
              ],
            ),
          ),
        ),
        heroTag: null,
        tooltip: '当前词语解释',
        elevation: 4,
        highlightElevation: 0,
        onPressed: () {
          final bool loginState = context.read<UserProvider>().loginState;
          final String type = context.read<WordOptionsProvider>().type;
          final bool couples = context.read<WordOptionsProvider>().couples;
          if (couples) {
            final SnackBar snackBar = SnackBar(
              content: const Text('情侣模式下无法使用词典功能'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (loginState && type == '中国风') {
            Explanation.instance.getExplanationData(
              word: _word,
              context: context,
            );
          } else {
            String tips;
            if (!loginState) {
              tips = '请先登录再使用词典功能';
            } else if (type != '中国风') {
              tips = '只有在中国风状态下可以使用词典';
            }
            final SnackBar snackBar = SnackBar(
              content: Text(tips),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat,
        0,
        -160.h,
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        //垂直滑动切换类型
        onVerticalDragStart: (DragStartDetails details) {
          final WordOptionsProvider wordOptionsProviderprovider =
              context.read<WordOptionsProvider>();
          if (wordOptionsProviderprovider.type == '中国风') {
            wordOptionsProviderprovider.changeType('日式');
          } else {
            wordOptionsProviderprovider.changeType('中国风');
          }
          final SnackBar snackBar = SnackBar(
            content: Text('类型切换：${wordOptionsProviderprovider.type}'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Display(
                word: _word,
                word2: _word2,
                type: _type,
                romaji: _romaji,
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
                    textColor:
                        context.watch<SkinProvider>().color['background'],
                    borderColor: Style.defaultColor['button'],
                    callback: () => _getData(),
                  ),
                  CustomButton(
                    text: '選項',
                    bgColor: Style.defaultColor['background'],
                    textColor: Style.defaultColor['button'],
                    borderColor: Style.defaultColor['button'],
                    callback: () => showGeneralDialog(
                      context: context,
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> anim1,
                        Animation<double> anim2,
                      ) {
                        return OptionsDialog();
                      },
                      barrierColor: Colors.grey.withOpacity(.4),
                      transitionDuration: Duration(milliseconds: 400),
                      transitionBuilder: (
                        BuildContext context,
                        Animation<double> anim1,
                        Animation<double> anim2,
                        Widget child,
                      ) {
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 25.h,
              ),
              child: Text(
                '提示：单击文字复制，长按加收藏，上划快速切换类型',
                style: TextStyle(
                  fontSize: 12,
                  color: context.watch<SkinProvider>().color['subtitle'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Display extends StatefulWidget {
  final String word, word2, type, romaji;

  Display({
    @required this.word,
    this.word2,
    @required this.type,
    this.romaji,
  });

  @override
  _DisplayState createState() => _DisplayState();
}

//图片/文字显示区域
class _DisplayState extends State<Display> with SingleTickerProviderStateMixin {
  final Duration _duration = Duration(milliseconds: 500);
  AnimationController _controller;
  Animation<double> _opacityAnimation, _sizeAnimation;
  final _opacityTween = Tween<double>(begin: 1.0, end: 0.0);
  final _sizeTween = Tween<double>(begin: 0.0, end: 120.0);

  Future<void> _love() async {
    try {
      final String path = API.favourite;
      await Request(
        context: context,
      ).httpPost(
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool couples = context.watch<WordOptionsProvider>().couples;
    return Column(
      children: <Widget>[
        Container(
          child: Builder(
            builder: (BuildContext context) {
              final type = context.watch<WordOptionsProvider>().type;
              final couples = context.watch<WordOptionsProvider>().couples;
              if (couples) {
                return Image(
                  image: AssetImage('assets/images/theme/couples.png'),
                  width: 200.w,
                );
              }
              if (type == '中国风') {
                return Image(
                  image: AssetImage(
                      'assets/images/theme/chinese-default-theme.png'),
                  width: 170.w,
                );
              } else {
                return Image(
                  image: AssetImage(
                      'assets/images/theme/japanese-default-theme.png'),
                  width: 170.w,
                );
              }
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!couples) {
              Clipboard.setData(ClipboardData(text: widget.word));
            } else {
              Clipboard.setData(
                  ClipboardData(text: '${widget.word} ${widget.word2}'));
            }
            final SnackBar snackBar = SnackBar(
              content: const Text('复制成功'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          onLongPress: () {
            if (!couples) {
              final bool loginState = context.read<UserProvider>().loginState;
              if (loginState) {
                _controller.forward();
                _love();
              } else {
                final SnackBar snackBar = SnackBar(
                  content: const Text('请先登录再添加收藏'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                top: 0,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Icon(
                    Icons.favorite,
                    size: _sizeAnimation.value,
                    color: Color(0xffff6b81),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20.h,
                ),
                child: Column(
                  children: <Widget>[
                    Offstage(
                      offstage: couples,
                      child: Text(
                        widget.word,
                        style: TextStyle(
                          fontSize: widget.word.length > 5 ? 42 : 52,
                          letterSpacing: 8,
                          height: 1,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !couples,
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.word,
                            style: TextStyle(
                              fontSize: widget.word.length > 5 ? 38 : 46,
                              letterSpacing: 8,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            widget.word2,
                            style: TextStyle(
                              fontSize: widget.word.length > 5 ? 38 : 46,
                              letterSpacing: 8,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage:
                          !context.watch<LaboratoryOptionsProvider>().romaji,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 15.h,
                        ),
                        child: Text(
                          widget.romaji,
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 8,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    final InheritedSelect inheritedSelect = InheritedSelect.of(context);
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
      child: Select(inheritedSelect.currentValue),
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

  //提示VIP弹窗
  void _promptVip() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return VipTipsDialog('查询此字数的ID需要开通VIP');
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
  }

  @override
  Widget build(BuildContext context) {
    final InheritedSelect inheritedSelect = InheritedSelect.of(context);
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
          bool vip = context.read<UserProvider>().vip;
          if (Utils.isNumber(newValue) && int.parse(newValue) > 5 && !vip) {
            _promptVip();
          } else {
            setState(() {
              dropdownValue = newValue;
              inheritedSelect.callback(newValue);
            });
          }
        },
        dropdownColor: context.watch<SkinProvider>().color['background'],
        items:
            inheritedSelect.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Builder(
              builder: (BuildContext content) {
                if (Utils.isNumber(value) && int.parse(value) > 5) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        value,
                        style: TextStyle(
                          height: 1.25,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/vip/vip_tip.png'),
                        width: 42.w,
                      ),
                    ],
                  );
                } else {
                  return Text(value);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

//选项弹窗
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
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              color: context.watch<SkinProvider>().color['widget'],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: const Text(
                    '选项',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InheritedSelect(
                  list: OptionsData.typeList,
                  callback: (String newValue) {
                    context.read<WordOptionsProvider>().changeType(newValue);
                  },
                  currentValue: context.watch<WordOptionsProvider>().type,
                  child: SelectBox(),
                ),
                InheritedSelect(
                  list: OptionsData.lengthList,
                  callback: (String newValue) {
                    context.read<WordOptionsProvider>().changeNumber(newValue);
                  },
                  currentValue: context.watch<WordOptionsProvider>().length,
                  child: SelectBox(),
                ),
                Offstage(
                  offstage: !context.watch<UserProvider>().vip,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 80.w,
                    ),
                    child: CheckboxListTile(
                      activeColor: Style.defaultColor['activeSwitchTrack'],
                      title: const Text('情侣模式'),
                      value: context.watch<WordOptionsProvider>().couples,
                      onChanged: (bool value) => context
                          .read<WordOptionsProvider>()
                          .changeCouples(value),
                    ),
                  ),
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
                    callback: () => Navigator.pop(context),
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
