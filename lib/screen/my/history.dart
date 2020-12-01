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
      final String path = API.history;
      final Response res = await Request(
        context: context,
      ).httpGet(path + '?page=$_page');
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
      }
    } catch (err) {
      print(err);
    }
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
  Widget build(BuildContext context) {
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
            return ListItem(
              type: _list[index]['type'],
              word: _list[index]['word'],
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
        padding: EdgeInsets.all(
          15.w,
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
                left: 15.w,
              ),
              child: Text(
                word,
                style: TextStyle(fontSize: 16),
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
