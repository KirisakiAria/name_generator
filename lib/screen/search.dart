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

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      print('input ${controller.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              color: Colors.black12,
            ),
            margin: EdgeInsets.only(
              top: 70.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    inputFormatters: [
                      //长度限制10
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xff25D1D1),
                        Color(0xff3BE6AD),
                        Color(0xff20DDAA)
                      ],
                    ),
                  ),
                  child: RaisedButton.icon(
                    elevation: 0,
                    disabledElevation: 0,
                    highlightElevation: 0,
                    splashColor: Colors.white,
                    shape: CircleBorder(),
                    icon: Icon(Icons.search),
                    label: new Text(''),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
