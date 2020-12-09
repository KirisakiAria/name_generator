//核心库
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//组件
import '../../widgets/loading_view.dart';
import '../../widgets/vip_tips_dialog.dart';
import '../../widgets/custom_button.dart';
//common
import '../../common/loading_status.dart';
import '../../common/style.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';
//utils
import '../../utils/floating_action_button.dart';
import '../../utils/explanation.dart';

enum SearchType {
  //一般模式
  NORMAL,
  //情侣模式
  COUPLES,
  //生成情侣名
  GENERATE
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final FocusNode blankNode = FocusNode();
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  String _searchText = '';
  List<dynamic> _list = <dynamic>[];
  List<int> _randomList = <int>[1, 2, 3, 4, 5];
  int _page = 0;

  SearchType _searchType = SearchType.NORMAL;

  List<int> _getRandomList() {
    int t;
    List<int> arr = <int>[1, 2, 3, 4, 5];
    for (int i = 0; i < arr.length; i++) {
      Random random = Random();
      int rand = random.nextInt(arr.length);
      t = arr[rand];
      arr[rand] = arr[i];
      arr[i] = t;
    }
    return arr;
  }

  Future<void> _getData(String searchText) async {
    try {
      final String path = API.search;
      Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'searchContent': searchText,
          'currentPage': _page,
          'searchType': _searchType.toString(),
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          final int length = res.data['data']['list'].length;
          if (length == 0) {
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else if (length < 15) {
            _list.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
            _page++;
          } else {
            _list.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_IDEL;
            _page++;
          }
        });
      } else {
        _loadingStatus = LoadingStatus.STATUS_COMPLETED;
      }
    } catch (err) {
      print(err);
    }
  }

  void _search({String searchText, bool refresh = false}) {
    final bool loginState = context.read<UserProvider>().loginState;
    if (!loginState) {
      final SnackBar snackBar = SnackBar(
        content: const Text('请先登录再使用搜索功能'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (_loadingStatus != LoadingStatus.STATUS_LOADING) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        setState(() {
          if (searchText != null) {
            _randomList = _getRandomList();
            _searchText = searchText;
          }
          if (_searchText == '') {
            final SnackBar snackBar = SnackBar(
              content: const Text('请输入关键字'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            if (refresh) {
              _page = 0;
              _list = <dynamic>[];
            }
            _loadingStatus = LoadingStatus.STATUS_LOADING;
            _getData(_searchText);
          }
        });
      }
    }
  }

  //提示VIP弹窗
  void _promptVip() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return VipTipsDialog('使用高级搜索选项需要开通VIP');
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

  //设置弹窗
  void _showSetting() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('搜索选项'),
              scrollable: true,
              content: SizedBox(
                width: 350.w,
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                      activeColor: Style.defaultColor['activeSwitchTrack'],
                      value: SearchType.NORMAL,
                      onChanged: (value) {
                        setState(() {
                          _list = <dynamic>[];
                          _searchType = value;
                        });
                      },
                      groupValue: _searchType,
                      title: const Text('一般模式'),
                      subtitle: const Text('查询一般网名'),
                      selected: _searchType == SearchType.NORMAL,
                    ),
                    RadioListTile(
                      activeColor: Style.defaultColor['activeSwitchTrack'],
                      value: SearchType.COUPLES,
                      onChanged: (value) {
                        setState(() {
                          _list = <dynamic>[];
                          _searchType = value;
                        });
                      },
                      groupValue: _searchType,
                      title: const Text('情侣模式'),
                      subtitle: const Text('查询情侣网名'),
                      selected: _searchType == SearchType.COUPLES,
                    ),
                    RadioListTile(
                      activeColor: Style.defaultColor['activeSwitchTrack'],
                      value: SearchType.GENERATE,
                      onChanged: (value) {
                        setState(() {
                          _list = <dynamic>[];
                          _searchType = value;
                        });
                      },
                      groupValue: _searchType,
                      title: const Text('生成情侣名'),
                      subtitle: const Text('根据提供的网名自动查询或生成对应的情侣名'),
                      selected: _searchType == SearchType.GENERATE,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 40.h,
                      ),
                      child: CustomButton(
                        text: '確認',
                        bgColor: context.watch<SkinProvider>().color['button'],
                        textColor:
                            context.watch<SkinProvider>().color['background'],
                        borderColor: Style.defaultColor['button'],
                        paddingVertical: 14.h,
                        callback: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.only(
                right: 12.h,
                bottom: 12.h,
              ),
            );
          },
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 65.w,
          height: 65.w,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 34,
          ),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xffFF3CAC),
                Color(0xff9861C7),
              ],
            ),
          ),
        ),
        heroTag: null,
        tooltip: '切换搜索模式',
        elevation: 4,
        highlightElevation: 0,
        onPressed: () {
          final bool vip = context.read<UserProvider>().vip;
          if (!vip) {
            _promptVip();
          } else {
            _showSetting();
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
        onTap: () => FocusScope.of(context).requestFocus(blankNode),
        child: InheritedContext(
          searchText: _searchText,
          search: _search,
          searchType: _searchType,
          list: _list,
          loadingStatus: _loadingStatus,
          randomList: _randomList,
          child: Column(
            children: <Widget>[
              SearchInput(blankNode),
              SearchList(),
            ],
          ),
        ),
      ),
    );
  }
}

class InheritedContext extends InheritedWidget {
  //选择之后回调
  final void Function({@required String searchText, bool refresh}) search;
  //搜索文本
  final String searchText;
  //搜索模式
  final SearchType searchType;
  //列表
  final List<dynamic> list;
  //列表加载状态
  final LoadingStatus loadingStatus;
  //随机数列表
  final List<int> randomList;

  InheritedContext({
    Key key,
    @required this.searchText,
    @required this.search,
    @required this.searchType,
    @required this.list,
    @required this.loadingStatus,
    @required this.randomList,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedContext>();
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(InheritedContext oldWidget) {
    return searchText != oldWidget.searchText;
  }
}

class SearchInput extends StatelessWidget {
  //设置成静态是为了不让textfield的值被清空
  static final TextEditingController _controller = TextEditingController();
  final FocusNode blankNode;
  SearchInput(this.blankNode);

  @override
  Widget build(BuildContext context) {
    final InheritedContext inheritedContext = InheritedContext.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 80.h,
        bottom: 25.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          right: 10.w,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          color: context.watch<SkinProvider>().color['searchInput'],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                inputFormatters: [
                  //长度限制10
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  border: InputBorder.none,
                  hintText: '根据关键字搜索网名',
                  hintStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Container(
              width: 36.w,
              height: 36.w,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xffFBAB7E),
                    Color(0xffF7CE68),
                  ],
                ),
              ),
              child: MaterialButton(
                padding: EdgeInsets.all(0),
                elevation: 0,
                disabledElevation: 0,
                highlightElevation: 0,
                splashColor: Colors.white,
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () {
                  inheritedContext.search(
                    searchText: _controller.text,
                    refresh: true,
                  );
                  FocusScope.of(context).requestFocus(blankNode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerPlaceholder = ScrollController();

  final Duration _duration = Duration(milliseconds: 500);
  AnimationController _animationController;
  Animation<double> _opacityAnimation, _sizeAnimation;
  final _opacityTween = Tween<double>(begin: 1.0, end: 0.0);
  final _sizeTween = Tween<double>(begin: 0.0, end: 120.0);

  int _lovedIndex;

  AssetImage _randomBackground(index) {
    final InheritedContext inheritedContext = InheritedContext.of(context);
    final List<int> randomList = inheritedContext.randomList;
    switch (index % 10) {
      case 0:
        return AssetImage('assets/images/search/bg${randomList[0]}.png');
        break;
      case 1:
        return AssetImage('assets/images/search/card1.png');
        break;
      case 2:
        return AssetImage('assets/images/search/bg${randomList[1]}.png');
        break;
      case 3:
        return AssetImage('assets/images/search/card2.png');
        break;
      case 4:
        return AssetImage('assets/images/search/bg${randomList[2]}.png');
        break;
      case 5:
        return AssetImage('assets/images/search/card3.png');
        break;
      case 6:
        return AssetImage('assets/images/search/bg${randomList[3]}.png');
        break;
      case 7:
        return AssetImage('assets/images/search/card4.png');
        break;
      case 8:
        return AssetImage('assets/images/search/bg${randomList[4]}.png');
        break;
      case 9:
        return AssetImage('assets/images/search/card5.png');
        break;
      default:
        return AssetImage('assets/images/search/bg${randomList[5]}.png');
        break;
    }
  }

  Future<void> _love({
    @required String type,
    @required int length,
    @required String word,
  }) async {
    try {
      final String path = API.favourite;
      await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'type': type,
          'length': length,
          'word': word,
        },
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // 用于实时更新_animation.value
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 监听动画完成的状态
          _animationController.reset();
        }
      });
    CurvedAnimation curvedanimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _sizeAnimation = _sizeTween.animate(curvedanimation);
    _opacityAnimation = _opacityTween.animate(curvedanimation);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerPlaceholder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InheritedContext inheritedContext = InheritedContext.of(context);
    final LoadingStatus loadingStatus = inheritedContext.loadingStatus;
    final List<dynamic> list = inheritedContext.list;
    final searchType = inheritedContext.searchType;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (loadingStatus == LoadingStatus.STATUS_IDEL) {
          inheritedContext.search();
        }
      }
    });
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 0),
        controller: _scrollController,
        children: <Widget>[
          StaggeredGridView.countBuilder(
            controller: _scrollControllerPlaceholder,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            crossAxisCount: 4,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                if (searchType == SearchType.COUPLES) {
                  Clipboard.setData(ClipboardData(
                      text:
                          '${list[index]['words'][0]} ${list[index]['words'][1]}'));
                } else {
                  Clipboard.setData(ClipboardData(text: list[index]['word']));
                }
                final SnackBar snackBar = SnackBar(
                  content: const Text('复制成功'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              onDoubleTap: () {
                if (searchType == SearchType.NORMAL) {
                  final Map<String, dynamic> item = list[index];
                  if (item['type'] == '中国风') {
                    Explanation.instance.getExplanationData(
                      word: item['word'],
                      context: context,
                    );
                  } else {
                    final SnackBar snackBar = SnackBar(
                      content: const Text('只有在中国风词语才可以使用词典'),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              onLongPress: () {
                if (searchType == SearchType.NORMAL) {
                  final bool loginState =
                      context.read<UserProvider>().loginState;
                  if (loginState) {
                    _lovedIndex = index;
                    _animationController.forward();
                    final Map<String, dynamic> item = list[index];
                    _love(
                      type: item['type'],
                      length: item['length'],
                      word: item['word'],
                    );
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
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: _randomBackground(index),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        if (searchType == SearchType.COUPLES) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                list[index]['words'][0],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(245, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                list[index]['words'][1],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(245, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              list[index]['word'],
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 8.0,
                                    color: Color.fromARGB(245, 255, 255, 255),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned.fill(
                    top: -15.h,
                    child: Opacity(
                      opacity:
                          _lovedIndex == index ? _opacityAnimation.value : 0,
                      child: Icon(
                        Icons.favorite,
                        size: _sizeAnimation.value,
                        color: Color(0xffff6b81),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(2, index == 1 ? 0.9 : 1.1),
            mainAxisSpacing: 18.h,
            crossAxisSpacing: 14.w,
          ),
          Offstage(
            offstage: list.length == 0,
            child: LoadingView(loadingStatus),
          ),
        ],
      ),
    );
  }
}
