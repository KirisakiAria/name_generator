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
import 'package:like_button/like_button.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
//model
import '../model/word_options.dart';
import '../model/user.dart';
import '../model/skin.dart';
import '../model/laboratory_options.dart';

class InspirationPage extends StatefulWidget {
  @override
  _InspirationPageState createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage>
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
  };
  int _likeCount = 0;
  bool _isLike = false;

  Future<bool> _getData() async {
    final String path = API.inspiration;
    final Response res = await Request(context: context).httpGet(path);
    if (res.data['code'] == '1000') {
      setState(() {
        _chinese = res.data['data']['chinese'];
        _japanese = res.data['data']['japanese'];
      });
    }
  }

  Future<bool> _like(bool islike) async {
    _isLike = !_isLike;
    return _isLike;
    // final String path = API.likeInspiration;
    // final Response res = await Request(context: context).httpPost(path, islike);
    // if (res.data['code'] == '1000') {
    //   setState(() {
    //     _isLike = islike;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        color: Style.grey20,
        backgroundColor: Colors.white,
        onRefresh: _getData,
        child: ListView(
          padding: EdgeInsets.only(
            top: 90.h,
          ),
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 205.w,
                    padding: EdgeInsets.only(left: 15.w, top: 20.h),
                    child: Text(
                        '歡迎來到靈感探求頁面。在這個頁面裏，我們會不断更新適合發掘出網名精選的精選詩詞和故事。希望能夠盤活您的思緒之泉 ฅ･◡･ฅ',
                        style: TextStyle(
                          fontFamily: 'NijimiMincho',
                          letterSpacing: 0.8,
                          height: 1.5,
                          fontSize: 12,
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 165.w,
                    child: Image(
                      image: AssetImage('assets/images/inspiration/top.png'),
                    ),
                  ),
                ),
              ],
            ),
            _InspirationItem(
              title: _chinese['title'],
              author: _chinese['author'],
              content: _chinese['content'],
            ),
            Align(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30.h),
                width: 200.w,
                child: Image(
                  image: AssetImage('assets/images/inspiration/middle.png'),
                ),
              ),
            ),
            _InspirationItem(
              title: _japanese['title'],
              author: _japanese['author'],
              content: _japanese['content'],
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 40.h,
              ),
              child: LikeButton(
                onTap: (bool islike) => _like(islike),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: const Color(0xFFff7f50),
                  dotSecondaryColor: const Color(0xFF70a1ff),
                  dotThirdColor: const Color(0xFF7bed9f),
                  dotLastColor: const Color(0xFFff6b81),
                ),
                likeCount: 0,
                isLiked: _isLike,
                countPostion: CountPostion.bottom,
                countBuilder: (int count, bool isLiked, String text) {
                  Color color = isLiked ? Color(0xffff4081) : Colors.grey;
                  return Container(
                    padding: EdgeInsets.only(top: 14.h),
                    child: Text(
                      text,
                      style: TextStyle(color: color),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InspirationItem extends StatelessWidget {
  final String title, author, content;
  _InspirationItem({
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
            margin: EdgeInsets.symmetric(vertical: 8.h),
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
                letterSpacing: 2,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
