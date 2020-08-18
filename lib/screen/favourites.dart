//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求相关
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/loading_status.dart';
import '../common/custom_icon_data.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '收藏',
        ),
      ),
      body: FavouritesList(),
    );
  }
}

class FavouritesList extends StatefulWidget {
  @override
  _FavouritesListState createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {
  List<dynamic> favouritesList = <dynamic>[];
  ScrollController _scrollController = ScrollController();
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  int page = 0;

  Future<void> _getData({bool refresh = true}) async {
    try {
      if (refresh) {
        page = 0;
        favouritesList.clear();
      }
      _loadingStatus = LoadingStatus.STATUS_LOADING;
      final String path = API.favourite;
      final Response res =
          await Request.init(context: context).httpGet(path + '?page=$page');
      if (res.data['code'] == '1000') {
        setState(() {
          int length = res.data['data']['list'].length;
          if (length > 0 && length < 15) {
            favouritesList.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else if (length > 15) {
            favouritesList.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_IDEL;
            page++;
          } else {
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          }
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(refresh: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadingStatus == LoadingStatus.STATUS_IDEL) {
          _getData(refresh: false);
        }
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        controller: _scrollController,
        itemCount: favouritesList.length + 1,
        itemBuilder: (context, index) {
          if (index == favouritesList.length) {
            return _LoadingView(_loadingStatus);
          } else {
            return ListItem(
              type: favouritesList[index]['type'],
              word: favouritesList[index]['word'],
              callback: _getData,
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String type, word;
  final void Function() callback;
  ListItem({
    @required this.type,
    @required this.word,
    @required this.callback,
  });

  Future<void> _cancel({
    @required String word,
    @required BuildContext context,
  }) async {
    try {
      final String path = API.favourite;
      final Response res =
          await Request.init(context: context).httpDelete('$path/$word');
      if (res.data['code'] == '1000') {
        callback();
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 6.h,
      ),
      padding: EdgeInsets.all(15.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          WordIcon(type),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: word));
              final SnackBar snackBar = SnackBar(
                content: const Text('复制成功'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 15.w,
              ),
              child: Text(
                this.word,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: FlatButton(
                  child: Text(
                    '取消收藏',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                  ),
                  onPressed: () {
                    _cancel(
                      word: word,
                      context: context,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  final LoadingStatus _loadingStatus;
  _LoadingView(this._loadingStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            const IconData(
              CustomIconData.cat,
              fontFamily: 'iconfont',
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 12.w,
            ),
            child: Builder(
              builder: (conext) {
                if (_loadingStatus == LoadingStatus.STATUS_IDEL) {
                  return const Text('上拉加载更多');
                } else if (_loadingStatus == LoadingStatus.STATUS_LOADING) {
                  return const Text('加载中');
                }
                return const Text('加载完成');
              },
            ),
          ),
        ],
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
      return Icon(
        const IconData(
          CustomIconData.chinese,
          fontFamily: 'iconfont',
        ),
        color: Colors.pinkAccent,
      );
    }
    return Icon(
      const IconData(
        CustomIconData.japanese,
        fontFamily: 'iconfont',
      ),
      color: Colors.blue,
    );
  }
}
