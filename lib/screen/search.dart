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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/loading_view.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
import '../common/loading_status.dart';
//model
import '../model/word_options.dart';
import '../model/user.dart';
import '../model/skin.dart';
import '../model/laboratory_options.dart';

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
  int _page = 0;

  Future<void> _getData(String searchText) async {
    try {
      final String path = API.search;
      Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'searchContent': searchText,
          'pageSize': 20,
          'currentPage': _page,
        },
      );
      if (res.data['code'] == '1000') {
        setState(() {
          final int length = res.data['data']['list'].length;
          if (length == 0) {
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
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
      Scaffold.of(context).removeCurrentSnackBar();
      setState(() {
        if (searchText != null) {
          _searchText = searchText;
        }
        if (_searchText == '') {
          final SnackBar snackBar = SnackBar(content: Text('请输入关键字'));
          Scaffold.of(context).showSnackBar(snackBar);
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

  InheritedContext({
    Key key,
    @required this.searchText,
    @required this.search,
    @required this.list,
    @required this.loadingStatus,
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
  //设置成静态是为了不让textfiled的值被清空
  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final InheritedContext inheritedContext = InheritedContext.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 70.h,
        bottom: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10.w),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          color: Color(0xFFf5f5f5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
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
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              width: 32.w,
              height: 32.w,
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
                    searchText: controller.text,
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

class _SearchListState extends State<SearchList> {
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerPlaceholder = ScrollController();

  LinearGradient _randomColor(index) {
    if (index % 5 == 0) {
      return LinearGradient(
        colors: <Color>[
          Color(0xffffecd2),
          Color(0xfffcb69f),
        ],
      );
    } else if (index % 4 == 0) {
      return LinearGradient(
        colors: <Color>[
          Color(0xffff9a9e),
          Color(0xffF7CE68),
        ],
      );
    } else if (index % 3 == 0) {
      return LinearGradient(
        colors: <Color>[
          Color(0xffff9a9e),
          Color(0xfffad0c4),
        ],
      );
    } else if (index % 2 == 0) {
      return LinearGradient(
        colors: <Color>[
          Color(0xfffad0c4),
          Color(0xfffda085),
        ],
      );
    } else {
      return LinearGradient(
        colors: <Color>[
          Color(0xffFF99AC),
          Color(0xfffda085),
        ],
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(snackBar);
              },
              child: Container(
                decoration: ShapeDecoration(
                  gradient: _randomColor(index),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  shadows: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xffe2e2e2),
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    list[index]['word'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(2, index == 1 ? 0.7 : 0.9),
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
