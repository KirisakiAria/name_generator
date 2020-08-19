//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求相关
import '../services/api.dart';
import '../services/request.dart';
//model
import '../model/skin.dart';
//common
import '../common/loading_status.dart';
import '../common/custom_icon_data.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '查询记录',
        ),
      ),
      body: HistoryList(),
    );
  }
}

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<dynamic> historyList = <dynamic>[];
  ScrollController _scrollController = ScrollController();
  LoadingStatus _loadingStatus = LoadingStatus.STATUS_IDEL;
  int page = 0;

  Future<void> _getData({bool refresh = true}) async {
    try {
      if (refresh) {
        page = 0;
        historyList.clear();
      }
      _loadingStatus = LoadingStatus.STATUS_LOADING;
      final String path = API.history;
      final Response res =
          await Request.init(context: context).httpGet(path + '?page=$page');
      if (res.data['code'] == '1000') {
        setState(() {
          int length = res.data['data']['list'].length;
          if (length > 0 && length < 15) {
            historyList.addAll(res.data['data']['list']);
            _loadingStatus = LoadingStatus.STATUS_COMPLETED;
          } else if (length >= 15) {
            historyList.addAll(res.data['data']['list']);
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
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        controller: _scrollController,
        itemCount: historyList.length + 1,
        itemBuilder: (context, index) {
          if (index == historyList.length) {
            return _LoadingView(_loadingStatus);
          } else {
            return ListItem(
              type: historyList[index]['type'],
              word: historyList[index]['word'],
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String type, word;
  ListItem({
    @required this.type,
    @required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 6.h,
      ),
      padding: EdgeInsets.all(15.w),
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
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            const IconData(
              CustomIconData.cat,
              fontFamily: 'iconfont',
            ),
            color: context.watch<SkinProvider>().color['text'],
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
