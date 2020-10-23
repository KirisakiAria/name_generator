//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//common
import '../common/style.dart';
//model
import '../model/user.dart';
import '../model/skin.dart';

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
  bool _isLiked = false;
  String _id;

  Future<void> _getData() async {
    final String path = API.inspiration;
    final Response res = await Request(context: context).httpGet(path);
    if (res.data['code'] == '1000') {
      setState(() {
        _id = res.data['data']['id'];
        _chinese = res.data['data']['chinese'];
        _japanese = res.data['data']['japanese'];
        _likeCount = res.data['data']['likeCount'];
        _isLiked = res.data['data']['isLiked'];
      });
    }
  }

  Future<bool> _like(bool islike) async {
    bool loginState = context.read<UserProvider>().loginState;
    if (!loginState) {
      final SnackBar snackBar = SnackBar(content: Text('请先登录'));
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
      return false;
    }
    final String path = API.likeInspiration;
    final Response res = await Request(context: context).httpPut(
      path + '/$_id',
      <String, bool>{
        'islike': islike,
      },
    );
    if (res.data['code'] == '1000') {
      _isLiked = !_isLiked;
      if (islike) {
        _likeCount--;
      } else {
        _likeCount++;
      }
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {});
      });
    }
    return _isLiked;
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
                margin: EdgeInsets.symmetric(
                  vertical: 20.h,
                ),
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
              child: Center(
                child: Text(
                  '如果喜欢就来点个赞吧 ฅ･◡･ฅ',
                  style: TextStyle(
                    letterSpacing: 0.8,
                    color: context.watch<SkinProvider>().color['subtitle'],
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                top: 35.h,
                bottom: 20.h,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 40.h,
              ),
              child: LikeButton(
                size: 42,
                onTap: _like,
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: const Color(0xFFff7f50),
                  dotSecondaryColor: const Color(0xFF70a1ff),
                  dotThirdColor: const Color(0xFF7bed9f),
                  dotLastColor: const Color(0xFFff6b81),
                ),
                likeCount: _likeCount,
                isLiked: _isLiked,
                countPostion: CountPostion.bottom,
                countBuilder: (int count, bool isLiked, String text) {
                  Color color = isLiked ? Color(0xffff4081) : Colors.grey;
                  return Container(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
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
        vertical: 40.h,
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
