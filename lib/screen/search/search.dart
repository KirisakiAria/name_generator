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
//common
import '../../common/loading_status.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

final FocusNode blankNode = FocusNode();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;

  String _searchText = '';
  List<dynamic> _list = <dynamic>[];
  List<int> _randomList = <int>[1, 2, 3, 4, 5];
  int _page = 0;

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
      }
    } catch (err) {
      print(err);
    }
  }

  void _search({String searchText, bool refresh = false}) {
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
            _list = [];
          }
          _loadingStatus = LoadingStatus.STATUS_LOADING;
          _getData(_searchText);
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(blankNode),
        child: InheritedContext(
          searchText: _searchText,
          search: _search,
          list: _list,
          loadingStatus: _loadingStatus,
          randomList: _randomList,
          child: Column(
            children: <Widget>[
              SearchInput(),
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
          top: 2.h,
          bottom: 2.h,
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
                child: Icon(
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
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            crossAxisCount: 4,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: list[index]['word']));
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
              },
              child: Stack(
                children: <Widget>[
                  Container(
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
                    child: Center(
                      child: Text(
                        list[index]['word'],
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              color: Color.fromARGB(245, 255, 255, 255),
                            ),
                          ],
                        ),
                      ),
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
