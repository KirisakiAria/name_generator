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
import 'package:like_button/like_button.dart';
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

class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage>
    with AutomaticKeepAliveClientMixin {
  static const String shareContent = '【彼岸自在，最懂你的网名生成器】';
  String _word = '彼岸自在';
  String _word2 = '吾溪不归';
  String _type = '中国风';
  String _romaji = 'Higanjizai';
  bool _isLiked = false;
  int _likeCount = 0;
  String _id = '';

  GlobalKey<_GeneratorPageState> generatorKey = GlobalKey();

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
          _id = res.data['data']['id'];
          _word = res.data['data']['word'];
          _word2 = res.data['data']['word2'];
          _type = context.read<WordOptionsProvider>().type;
          _romaji = res.data['data']['romaji'];
          _likeCount = res.data['data']['likeCount'];
          _isLiked = res.data['data']['isLiked'];
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

  Future<bool> _like(bool islike) async {
    try {
      bool loginState = context.read<UserProvider>().loginState;
      if (!loginState) {
        final SnackBar snackBar = SnackBar(
          content: const Text('请先登录再点赞'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future<bool>.value(false);
      }
      final String path = API.likeWord;
      final Response res = await Request(
        context: context,
      ).httpPut(
        path + '/$_id',
        <String, dynamic>{
          'islike': islike,
          'type': _type,
          'couples': context.read<WordOptionsProvider>().couples,
        },
      );
      if (res.data['code'] == '1000') {
        _isLiked = !_isLiked;
        if (islike) {
          _likeCount--;
        } else {
          _likeCount++;
        }
        Future.delayed(
          Duration(milliseconds: 1000),
          () {
            setState(() {});
          },
        );
      }
      return Future<bool>.value(_isLiked);
    } catch (err) {
      print(err);
      return Future<bool>.value(false);
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
                children: <InlineSpan>[
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
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final dynamic accepted = prefs.getBool('accepted');
        accepted ?? _showAgreementPopup();
      } catch (err) {
        print(err);
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
        onVerticalDragStart: (DragStartDetails details) async {
          final WordOptionsProvider wordOptionsProviderprovider =
              context.read<WordOptionsProvider>();
          if (wordOptionsProviderprovider.type == '中国风') {
            wordOptionsProviderprovider.changeType('日式');
          } else {
            wordOptionsProviderprovider.changeType('中国风');
          }
          await _getData();
          final SnackBar snackBar = SnackBar(
            content: Text('类型切换：${wordOptionsProviderprovider.type}'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Column(
          children: <Widget>[
            Display(
              word: _word,
              word2: _word2,
              type: _type,
              romaji: _romaji,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30.h,
              ),
              child: Offstage(
                offstage: _id == '' ||
                    !context.watch<LaboratoryOptionsProvider>().likeWord,
                child: LikeButton(
                  size: 42,
                  onTap: _like,
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: const Color(0xFFff7f50),
                    dotSecondaryColor: const Color(0xFF70a1ff),
                    dotThirdColor: const Color(0xFF7bed9f),
                    dotLastColor: const Color(0xFFff6b81),
                  ),
                  likeCount: _likeCount,
                  isLiked: _isLiked,
                  countPostion: CountPostion.bottom,
                  countBuilder: (int count, bool isLiked, String text) {
                    Color color = isLiked ? Color(0xffff4081) : Colors.grey;
                    return Container(
                      padding: EdgeInsets.only(
                        top: 10.h,
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(),
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
                        return OptionsDialog(
                          getData: _getData,
                        );
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
                          child: OptionsDialog(
                            getData: _getData,
                          ),
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
                  top: 25.h,
                ),
                child: Column(
                  children: <Widget>[
                    Offstage(
                      offstage: couples,
                      child: Text(
                        widget.word,
                        style: TextStyle(
                          fontSize: widget.word.length > 5 ? 40.sp : 50.sp,
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
                              fontSize: widget.word.length > 5 ? 40.sp : 46.sp,
                              letterSpacing: 8,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            widget.word2,
                            style: TextStyle(
                              fontSize: widget.word.length > 5 ? 40.sp : 46.sp,
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

class Select extends StatefulWidget {
  final List<String> list;
  final String value;
  final bool Function(String newValue) callback;

  Select({
    @required this.list,
    @required this.value,
    @required this.callback,
  });

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: value,
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
            bool result = widget.callback(newValue);
            if (result) {
              setState(() {
                value = newValue;
              });
            }
          },
          dropdownColor: context.watch<SkinProvider>().color['background'],
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
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
      ),
    );
  }
}

//选项弹窗
class OptionsDialog extends Dialog {
  final Future<void> Function() getData;
  OptionsDialog({
    Key key,
    @required this.getData,
  }) : super(key: key);

  //提示VIP弹窗
  void _promptVip(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return VipTipsDialog('使用情侣模式需要开通VIP');
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
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 400.h,
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
                Select(
                  list: OptionsData.typeList,
                  value: context.watch<WordOptionsProvider>().type,
                  callback: (String newValue) {
                    bool vip = context.read<UserProvider>().vip;
                    if (Utils.isNumber(newValue) &&
                        int.parse(newValue) > 5 &&
                        !vip) {
                      _promptVip(context);
                      return false;
                    } else {
                      context.read<WordOptionsProvider>().changeType(newValue);
                      getData();
                      return true;
                    }
                  },
                ),
                Select(
                  list: OptionsData.lengthList,
                  value: context.watch<WordOptionsProvider>().length,
                  callback: (String newValue) {
                    bool vip = context.read<UserProvider>().vip;
                    if (Utils.isNumber(newValue) &&
                        int.parse(newValue) > 5 &&
                        !vip) {
                      _promptVip(context);
                      return false;
                    } else {
                      context
                          .read<WordOptionsProvider>()
                          .changeNumber(newValue);
                      getData();
                      return true;
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 74.w,
                  ),
                  child: CheckboxListTile(
                      activeColor: Style.defaultColor['activeSwitchTrack'],
                      title: const Text('情侣模式（中国风）'),
                      value: context.watch<WordOptionsProvider>().couples,
                      onChanged: (bool value) {
                        if (context.read<UserProvider>().vip) {
                          context
                              .read<WordOptionsProvider>()
                              .changeCouples(value);
                          getData();
                        } else {
                          _promptVip(context);
                        }
                      }),
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
