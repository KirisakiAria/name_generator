//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方包
import 'package:dio/dio.dart';
//请求相关
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/loading_status.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '收藏',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
          if (res.data['data']['list'].length > 0) {
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
        padding: EdgeInsets.symmetric(vertical: 6),
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
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: EdgeInsets.all(15),
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
          Icon(
            IconData(
              type == '中国风' ? 0xec15 : 0xe63f,
              fontFamily: 'iconfont',
            ),
            color: type == '中国风' ? Colors.pinkAccent : Colors.blue,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: word));
              final SnackBar snackBar = SnackBar(
                content: Text('复制成功'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15),
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
            IconData(
              0xe65e,
              fontFamily: 'iconfont',
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Builder(
              builder: (conext) {
                if (_loadingStatus == LoadingStatus.STATUS_IDEL) {
                  return Text('上拉加载更多');
                } else if (_loadingStatus == LoadingStatus.STATUS_LOADING) {
                  return Text('加载中');
                }
                return Text('加载完成');
              },
            ),
          ),
        ],
      ),
    );
  }
}
