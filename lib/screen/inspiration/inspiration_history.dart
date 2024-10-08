//核心库
import 'package:flutter/material.dart';
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

class InspirationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '灵感记录',
        ),
      ),
      body: InspirationHistoryList(),
    );
  }
}

class InspirationHistoryList extends StatefulWidget {
  @override
  _InspirationHistoryListState createState() => _InspirationHistoryListState();
}

class _InspirationHistoryListState extends State<InspirationHistoryList> {
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
      final String path = API.inspiration;
      final Response res = await Request(
        context: context,
      ).httpGet('$path?page=$_page');
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
              id: _list[index]['_id'],
              chineseTitle: _list[index]['chinese']['title'],
              chineseContent: _list[index]['chinese']['content'],
              japaneseTitle: _list[index]['japanese']['title'],
              japaneseContent: _list[index]['japanese']['content'],
              likedUsersCount: _list[index]['likedUsers'].length,
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String id, chineseTitle, chineseContent, japaneseTitle, japaneseContent;
  final int likedUsersCount;
  ListItem({
    @required this.id,
    @required this.chineseTitle,
    @required this.chineseContent,
    @required this.japaneseTitle,
    @required this.japaneseContent,
    @required this.likedUsersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 30.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.pushNamed(
          context,
          '/inspiration_history_details',
          arguments: <String, String>{
            'id': id,
          },
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 35.w,
              ),
              child: Column(
                children: <Widget>[
                  Icon(
                    const IconData(
                      CustomIconData.love,
                      fontFamily: 'iconfont',
                    ),
                    size: 30,
                    color: context.watch<SkinProvider>().color['text'],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15.h,
                    ),
                    child: Text(
                      likedUsersCount.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 250.w,
                  child: Text(
                    chineseTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: 250.w,
                  margin: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: Text(
                    chineseContent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
                Container(
                  width: 250.w,
                  margin: EdgeInsets.only(
                    top: 20.h,
                  ),
                  child: Text(
                    japaneseTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  width: 250.w,
                  margin: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: Text(
                    japaneseContent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
