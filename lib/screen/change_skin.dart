//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//model
import '../model/skin.dart';
//common
import '../common/style.dart';

class SkinPage extends StatefulWidget {
  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {
  final Color _color = Color(0xffe9ccd3);
  List<_Item> _items = <_Item>[];

  _initList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int themeIndex = prefs.getInt('themeIndex');
    List<_Item> _tempItems = <_Item>[];
    Style.themeList.asMap().forEach((index, value) {
      _tempItems.add(
        _Item(
          text: Style.themeNameList[index],
          themeIndex: index,
          selected: index == themeIndex ? true : false,
        ),
      );
    });
    setState(() {
      _items.addAll(_tempItems);
    });
  }

  @override
  void initState() {
    super.initState();
    _initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //修改颜色
        ),
        title: const Text(
          '切换皮肤',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: _color,
      ),
      backgroundColor: _color,
      body: Builder(
        builder: (contenxt) {
          return ListView(
            padding: EdgeInsets.all(20.w),
            children: _items,
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  final int themeIndex;
  final bool selected;

  _Item({
    @required this.text,
    @required this.themeIndex,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<SkinProvider>().changeTheme(
              theme: Style.themeList[themeIndex],
              color: Style.colorList[themeIndex],
            );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('themeIndex', themeIndex);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 20.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                color: Style.colorList[themeIndex]['background'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                shadows: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(120, 120, 120, 0.1), //阴影颜色
                    blurRadius: 6, //阴影大小
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              height: 60.w,
              width: 280.w,
            ),
            Container(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: 1.57,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 5,
                      fontFamily: 'NijimiMincho',
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
