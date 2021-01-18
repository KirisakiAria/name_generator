//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求相关
import '../../services/api.dart';
import '../../services/request.dart';
//组件
import '../../widgets/loading_view.dart';
//model
import '../../model/skin.dart';
//common
import '../../common/loading_status.dart';
import '../../common/custom_icon_data.dart';
import '../../common/style.dart';
//utils
import '../../utils/explanation.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '我的收藏',
          ),
          bottom: TabBar(
            indicatorColor:
                context.watch<SkinProvider>().color['indicatorColor'],
            unselectedLabelColor:
                context.watch<SkinProvider>().color['subtitle'],
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            tabs: <Widget>[
              Tab(
                text: '普通',
              ),
              Tab(
                text: '情侣',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FavouritesList('normal'),
            FavouritesList('couples'),
          ],
        ),
      ),
    );
  }
}

class FavouritesList extends StatefulWidget {
  final String type;
  FavouritesList(this.type);

  @override
  _FavouritesListState createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _list = <dynamic>[];
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  int _page = 0;

  Future<void> _getData({bool refresh = true}) async {
    try {
      if (refresh) {
        _page = 0;
        _list.clear();
      }
      _loadingStatus = LoadingStatus.STATUS_LOADING;
      final String path = API.favourite;
      final Response res = await Request(
        context: context,
      ).httpGet(path + '?page=$_page&type=${widget.type}');
      if (res.data['code'] == '1000') {
        setState(() {
          final int length = res.data['data']['list'].length;
          if (length == 0) {
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else if (length < 15) {
            _list.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
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

  void _cancel(int index) {
    setState(() {
      _list.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadingStatus == LoadingStatus.STATUS_IDEL) {
          _getData(refresh: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Style.grey20,
      backgroundColor: Colors.white,
      onRefresh: _getData,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        controller: _scrollController,
        itemCount: _list.length + 1,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          if (index == _list.length) {
            return LoadingView(_loadingStatus);
          } else {
            if (widget.type == 'normal') {
              return ListItemNormal(
                type: _list[index]['type'],
                word: _list[index]['word'],
                index: index,
                cancelCallBack: _cancel,
              );
            } else {
              return ListItemCouples(
                type: _list[index]['type'],
                words: _list[index]['words'],
                index: index,
                cancelCallBack: _cancel,
              );
            }
          }
        },
      ),
    );
  }
}

class ListItemNormal extends StatelessWidget {
  final String type, word;
  final int index;
  final Function(int index) cancelCallBack;

  ListItemNormal({
    @required this.type,
    @required this.word,
    @required this.index,
    @required this.cancelCallBack,
  });

  Future<void> _cancel({
    @required String word,
    @required int index,
    @required BuildContext context,
  }) async {
    try {
      final String path = API.favourite;
      final Response res = await Request(
        context: context,
      ).httpDelete('$path/$word');
      if (res.data['code'] == '1000') {
        cancelCallBack(index);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: word));
        final SnackBar snackBar = SnackBar(
          content: const Text('复制成功'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onLongPress: () {
        if (type == '中国风') {
          Explanation.instance.getExplanationData(
            word: word,
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
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 6.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 5.h,
        ),
        decoration: ShapeDecoration(
          color: context.watch<SkinProvider>().color['widget'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            WordIcon(type),
            Container(
              margin: EdgeInsets.only(
                left: 20.w,
              ),
              child: Text(
                word,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: TextButton(
                    child: Text(
                      '取消收藏',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.watch<SkinProvider>().color['subtitle'],
                      ),
                    ),
                    onPressed: () => _cancel(
                      word: word,
                      index: index,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItemCouples extends StatelessWidget {
  final String type;
  final List<dynamic> words;
  final int index;
  final Function(int index) cancelCallBack;

  ListItemCouples({
    @required this.type,
    @required this.words,
    @required this.index,
    @required this.cancelCallBack,
  });

  Future<void> _cancel({
    @required List<dynamic> words,
    @required int index,
    @required BuildContext context,
  }) async {
    try {
      final String path = API.favourite;
      final Response res = await Request(
        context: context,
      ).httpDelete('$path/${words[0]}?couples=1');
      if (res.data['code'] == '1000') {
        cancelCallBack(index);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: '${words[0]} ${words[1]}'));
        final SnackBar snackBar = SnackBar(
          content: const Text('复制成功'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 6.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 8.h,
        ),
        decoration: ShapeDecoration(
          color: context.watch<SkinProvider>().color['widget'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            WordIcon(type),
            Container(
              margin: EdgeInsets.only(
                left: 20.w,
              ),
              child: Column(
                children: [
                  Text(
                    words[0],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    words[1],
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: TextButton(
                    child: Text(
                      '取消收藏',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.watch<SkinProvider>().color['subtitle'],
                      ),
                    ),
                    onPressed: () => _cancel(
                      words: words,
                      index: index,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordIcon extends StatelessWidget {
  final String type;
  WordIcon(this.type);
  @override
  Widget build(BuildContext context) {
    if (type == '中国风') {
      return const Icon(
        const IconData(
          CustomIconData.chinese,
          fontFamily: 'iconfont',
        ),
        color: Colors.pinkAccent,
      );
    }
    return const Icon(
      const IconData(
        CustomIconData.japanese,
        fontFamily: 'iconfont',
      ),
      color: Colors.blue,
    );
  }
}
