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
  Map<String, dynamic> chinese = {
    'title': '',
    'author': '',
    'content': '',
  };
  Map<String, dynamic> japanese = {
    'title': '',
    'author': '',
    'content': '',
  };

  Future<void> _getData() async {
    final String path = API.inspiration;
    final Response res = await Request(context: context).httpGet(path);
    if (res.data['code'] == '1000') {
      setState(() {
        chinese = res.data['data']['chinese'];
        japanese = res.data['data']['japanese'];
      });
    }
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
                    width: 200.w,
                    padding: EdgeInsets.only(left: 20.w, top: 20.h),
                    child: Text(
                        '歡迎來到靈感探求頁面。在這個頁面裏，我們會不断更新適合發掘出網名精選的精選詩詞。希望能夠盤活您的思緒之泉 ฅ･◡･ฅ',
                        style: TextStyle(
                          fontFamily: 'NijimiMincho',
                          height: 1.5,
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 160.w,
                    child: Image(
                      image: AssetImage('assets/images/inspiration/top.png'),
                    ),
                  ),
                ),
              ],
            ),
            _InspirationItem(
              title: chinese['title'],
              author: chinese['author'],
              content: chinese['content'],
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
              title: japanese['title'],
              author: japanese['author'],
              content: japanese['content'],
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
      padding: EdgeInsets.all(20.w),
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
