//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//model
import '../model/skin.dart';
import '../common/style.dart';

class Explanation {
  static Explanation get instance => _getInstance();
  static Explanation _instance;

  static Explanation _getInstance() {
    if (_instance == null) {
      _instance = Explanation();
    }
    return _instance;
  }

  Future<void> getExplanationData({
    @required String word,
    @required BuildContext context,
  }) async {
    try {
      final String path = API.dictionary;
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, String>{
          'word': word,
        },
      );
      if (res.data['code'] == '1000') {
        _showExplanationPopup(data: res.data['data'], context: context);
      }
    } catch (err) {
      print(err);
    }
  }

  //词典弹窗
  void _showExplanationPopup({
    @required Map<String, dynamic> data,
    @required BuildContext context,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
      ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('词典'),
          scrollable: true,
          content: SizedBox(
            width: 355.w,
            height: 500.h,
            child: Column(
              children: <Widget>[
                Container(
                  height: 90.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemExtent: 54.w,
                    itemCount: data['characters'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Text(
                            data['characters'][index] != null
                                ? data['characters'][index]['pinyin']
                                : 'wu',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            data['characters'][index] != null
                                ? data['characters'][index]['word']
                                : '无',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                //词义
                Container(
                  margin: EdgeInsets.only(
                    bottom: 30.h,
                  ),
                  child: Builder(
                    builder: (BuildContext context) {
                      if (data['allWord'] != null) {
                        if (data['allWord']['word'].length == 1) {
                          return const Text('见下方释义');
                        }
                        return Text('整词释义：${data['allWord']['explanation']}');
                      }
                      return const Text('整词释义：暂无释义');
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: 0,
                    ),
                    itemCount: data['characters'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 15.h,
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${(index + 1).toString()}.',
                                  style: TextStyle(
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  data['characters'][index] != null
                                      ? data['characters'][index]['word']
                                      : '无',
                                  style: TextStyle(
                                    height: 1,
                                    color: context
                                        .watch<SkinProvider>()
                                        .color['subTitle'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 15.h,
                            ),
                            padding: EdgeInsets.only(
                              left: 14.w,
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '笔画：',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: context
                                        .watch<SkinProvider>()
                                        .color['subTitle'],
                                  ),
                                ),
                                Text(
                                  data['characters'][index] != null
                                      ? data['characters'][index]['strokes']
                                          .toString()
                                      : '无',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: context
                                        .watch<SkinProvider>()
                                        .color['subTitle'],
                                  ),
                                ),
                                Text(
                                  '    部首：',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: context
                                        .watch<SkinProvider>()
                                        .color['subTitle'],
                                  ),
                                ),
                                Text(
                                  data['characters'][index] != null
                                      ? data['characters'][index]['radicals']
                                      : '无',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: context
                                        .watch<SkinProvider>()
                                        .color['subTitle'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 15.h,
                            ),
                            padding: EdgeInsets.only(
                              left: 14.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  '释义：',
                                  style: TextStyle(
                                    height: 1.4,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data['characters'][index] != null
                                        ? data['characters'][index]
                                            ['explanation']
                                        : '无',
                                    style: TextStyle(
                                      height: 1.4,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CustomButton(
              text: '確認',
              bgColor: context.watch<SkinProvider>().color['button'],
              textColor: context.watch<SkinProvider>().color['background'],
              borderColor: Style.defaultColor['button'],
              paddingVertical: 14.h,
              callback: () => Navigator.pop(context),
            ),
          ],
          actionsPadding: EdgeInsets.only(
            right: 12.h,
            bottom: 12.h,
          ),
        );
      },
      barrierColor: Color.fromRGBO(0, 0, 0, .4),
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (
        BuildContext context,
        Animation<double> anim1,
        Animation<double> anim2,
        Widget child,
      ) {
        return Transform.scale(
          scale: anim1.value,
          child: child,
        );
      },
    );
  }
}
