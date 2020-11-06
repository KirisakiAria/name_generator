//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//common
import '../../common/style.dart';
//model
import '../../model/skin.dart';

class InspirationHistoryDetailsPage extends StatefulWidget {
  @override
  _InspirationHistoryDetailsPageState createState() =>
      _InspirationHistoryDetailsPageState();
}

class _InspirationHistoryDetailsPageState
    extends State<InspirationHistoryDetailsPage>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> _chinese = {
    'title': '',
    'author': '',
    'content': '',
  };
  Map<String, dynamic> _japanese = {
    'title': '',
    'author': '',
    'content': '',
    'titleTranslation': '',
    'contentTranslation': '',
  };

  Future<void> _getData() async {
    Map<String, String> arguments = ModalRoute.of(context).settings.arguments;
    final String path = API.inspiration;
    final Response res = await Request(
      context: context,
    ).httpGet('$path/${arguments['id']}');
    if (res.data['code'] == '1000') {
      setState(() {
        _chinese = res.data['data']['chinese'];
        _japanese = res.data['data']['japanese'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        _getData();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '灵感记录详情',
        ),
      ),
      body: RefreshIndicator(
        color: Style.grey20,
        backgroundColor: Colors.white,
        onRefresh: _getData,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _InspirationHistoryDetailsItem(
              title: _chinese['title'],
              author: _chinese['author'],
              content: _chinese['content'],
            ),
            _InspirationHistoryDetailsItem(
              title: _japanese['title'],
              author: _japanese['author'],
              content: _japanese['content'],
            ),
            Container(
              child: Text(
                '译文：',
                style: TextStyle(
                  letterSpacing: 0.8,
                  color: context.watch<SkinProvider>().color['subtitle'],
                ),
              ),
              margin: EdgeInsets.only(
                left: 25.w,
                bottom: 20.h,
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  _japanese['titleTranslation'],
                  style: TextStyle(
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 5.h,
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  _japanese['contentTranslation'],
                  style: TextStyle(
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 5.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InspirationHistoryDetailsItem extends StatelessWidget {
  final String title, author, content;
  _InspirationHistoryDetailsItem({
    @required this.title,
    @required this.author,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25.w,
        vertical: 35.h,
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            child: Text(
              author,
              style: TextStyle(
                color: context.watch<SkinProvider>().color['subtitle'],
              ),
            ),
          ),
          Container(
            child: Text(
              content,
              style: TextStyle(
                letterSpacing: 1.8,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
