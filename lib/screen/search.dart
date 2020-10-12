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

final FocusNode blankNode = FocusNode();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchText = '';

  void _search(String searchText) {
    _searchText = searchText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(blankNode),
        child: InheritedContext(
          searchText: _searchText,
          search: _search,
          child: Column(
            children: <Widget>[
              SearchInput(),
              List(),
            ],
          ),
        ),
      ),
    );
  }
}

class InheritedContext extends InheritedWidget {
  //选择之后回调
  final void Function(String searchTxt) search;
  //当前值
  final String searchText;

  InheritedContext({
    Key key,
    @required this.searchText,
    @required this.search,
    @required Widget child,
  }) : super(key: key, child: child);

  static InheritedContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedContext>();
  }

  //是否重建widget就取决于数据是否相同
  @override
  bool updateShouldNotify(InheritedContext oldWidget) {
    return searchText != oldWidget.searchText;
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedContext.of(context);
    return Container(
      padding: EdgeInsets.only(right: 10.w),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        color: Color(0xFFf5f5f5),
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
                hintText: '根据关键字搜索网名',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xffFBAB7E),
                  Color(0xffF7CE68),
                ],
              ),
            ),
            child: MaterialButton(
              padding: EdgeInsets.all(0),
              elevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              splashColor: Colors.white,
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                inheritedContext.search(controller.text);
                FocusScope.of(context).requestFocus(blankNode);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  @override
  Widget build(BuildContext context) {
    final inheritedContext = InheritedContext.of(context);
    return Center(
      child: Text(inheritedContext.searchText),
    );
  }
}
