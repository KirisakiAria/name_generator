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
import '../../common/word_options.dart';
import '../../common/custom_icon_data.dart';
//model
import '../../model/word_options.dart';
import '../../model/user.dart';
import '../../model/skin.dart';
import '../../model/laboratory_options.dart';
//utils
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
  int _currentIndex = 0;

  GlobalKey<_GeneratorPageState> generatorKey = GlobalKey();

  Future<void> _getData() async {
    try {
      final String path = API.word;
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'type': context.read<WordOptionsProvider>().type['value'],
          'length': context.read<WordOptionsProvider>().length['value'],
          'ifRomaji': context.read<LaboratoryOptionsProvider>().romaji,
          'couples': context.read<WordOptionsProvider>().couples,
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          _id = res.data['data']['id'];
          _word = res.data['data']['word'];
          _word2 = res.data['data']['word2'];
          _type = context.read<WordOptionsProvider>().type['value'];
          _romaji = res.data['data']['romaji'];
          _likeCount = res.data['data']['likeCount'];
          _isLiked = res.data['data']['isLiked'];
        });
      } else if (res.data['code'] == '3010') {
        context.read<WordOptionsProvider>().changeCouples(false);
        context.read<WordOptionsProvider>().changeType(WordOptions.typeList[0]);
        context
            .read<WordOptionsProvider>()
            .changeNumber(WordOptions.lengthList[1]);
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
              TextButton(
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
              TextButton(
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
          final String type = context.read<WordOptionsProvider>().type['value'];
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
          final bool vip = context.read<UserProvider>().vip;
          final WordOptionsProvider wordOptionsProvider =
              context.read<WordOptionsProvider>();
          if (!vip && _currentIndex == 1) {
            _currentIndex = -1;
          }
          if (_currentIndex == WordOptions.typeList.length - 1) {
            _currentIndex = -1;
          }
          _currentIndex++;
          wordOptionsProvider.changeType(WordOptions.typeList[_currentIndex]);
          await _getData();
          final SnackBar snackBar = SnackBar(
            content: Text('类型切换：${wordOptionsProvider.type['value']}'),
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
                top: 15.h,
              ),
              child: Offstage(
                offstage: _id == '' ||
                    !context.watch<LaboratoryOptionsProvider>().likeWord,
                child: LikeButton(
                  size: 33,
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
                    final Color color =
                        isLiked ? const Color(0xffff4081) : Colors.grey;
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
                    borderColor: context.watch<SkinProvider>().color['button'],
                    callback: () => _getData(),
                  ),
                  CustomButton(
                    text: '選項',
                    bgColor: Style.defaultColor['background'],
                    textColor: Style.defaultColor['button'],
                    borderColor: context.watch<SkinProvider>().color['button'],
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
                      barrierLabel: '',
                      barrierDismissible: true,
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
                '提示：单击文字复制，长按加收藏，上下划快速切换类型',
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
          'type': context.read<WordOptionsProvider>().type['value'],
          'length': context.read<WordOptionsProvider>().length['value'],
          'word': widget.word,
          'word2': widget.word2,
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
              if (couples) {
                return Image(
                  image: const AssetImage('assets/images/theme/couples.png'),
                  width: 160.w,
                );
              } else {
                return Image(
                  image: AssetImage(type['img'] ??
                      'assets/images/theme/chinese-default-theme.png'),
                  width: 160.w,
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
                  top: 15.h,
                ),
                child: Column(
                  children: <Widget>[
                    Offstage(
                      offstage: couples,
                      child: Text(
                        widget.word,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: widget.word.length > 5 ? 40 : 50,
                          letterSpacing: 7,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !couples,
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.word,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.word.length > 5 ? 38 : 44,
                              letterSpacing: 7,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            widget.word2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.word.length > 5 ? 38 : 44,
                              letterSpacing: 7,
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
                          top: 12.h,
                        ),
                        child: Text(
                          widget.romaji,
                          textAlign: TextAlign.center,
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
  final List<Map<String, dynamic>> list;
  final Map value;
  final bool Function(Map<String, dynamic> newValue) callback;

  Select({
    @required this.list,
    @required this.value,
    @required this.callback,
  });

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  Map value;

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
        child: DropdownButton<Map<String, dynamic>>(
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
          onChanged: (Map<String, dynamic> newValue) {
            bool result = widget.callback(newValue);
            if (result) {
              setState(() {
                value = newValue;
              });
            }
          },
          dropdownColor: context.watch<SkinProvider>().color['background'],
          items: widget.list
              .map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> item) =>
                    DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Builder(
                    builder: (BuildContext content) {
                      if (item['vip']) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item['value'],
                              style: TextStyle(
                                height: 1.25,
                              ),
                            ),
                            Image(
                              image:
                                  AssetImage('assets/images/vip/vip_tip.png'),
                              width: 42.w,
                            ),
                          ],
                        );
                      } else {
                        return Text(item['value']);
                      }
                    },
                  ),
                ),
              )
              .toList(),
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
  void _promptVip({
    @required BuildContext context,
    @required String tips,
  }) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return VipTipsDialog(tips);
      },
      barrierColor: Color.fromRGBO(0, 0, 0, .4),
      barrierLabel: '',
      barrierDismissible: true,
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
                  list: WordOptions.typeList,
                  value: context.watch<WordOptionsProvider>().type,
                  callback: (Map<String, dynamic> newValue) {
                    final bool vip = context.read<UserProvider>().vip;
                    if (newValue['vip'] && !vip) {
                      _promptVip(
                        context: context,
                        tips: '使用此类型需要开通VIP',
                      );
                      return false;
                    } else {
                      context.read<WordOptionsProvider>().changeType(newValue);
                      return true;
                    }
                  },
                ),
                Select(
                  list: WordOptions.lengthList,
                  value: context.watch<WordOptionsProvider>().length,
                  callback: (Map<String, dynamic> newValue) {
                    final bool vip = context.read<UserProvider>().vip;
                    if (newValue['vip'] && !vip) {
                      _promptVip(
                        context: context,
                        tips: '使用此字数需要开通VIP',
                      );
                      return false;
                    } else {
                      context
                          .read<WordOptionsProvider>()
                          .changeNumber(newValue);
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
                        } else {
                          _promptVip(
                            context: context,
                            tips: '使用情侣模式需要开通VIP',
                          );
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
                    borderColor: context.watch<SkinProvider>().color['button'],
                    callback: () {
                      getData();
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
