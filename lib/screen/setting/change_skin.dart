//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//model
import '../../model/skin.dart';
//common
import '../../common/style.dart';

class SkinPage extends StatefulWidget {
  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {
  final Color _color = Color(0xffe9ccd3);
  List<_Item> _items = <_Item>[];

  //初始化主题列表，根据Style类里的三个List填充
  Future<void> _initList() async {
    Style.themeList.asMap().forEach((index, value) {
      _items.add(
        _Item(
          text: Style.themeNameList[index],
          themeIndex: index,
        ),
      );
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
        builder: (BuildContext contenxt) {
          return ListView(
            padding: EdgeInsets.all(
              20.w,
            ),
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

  _Item({
    @required this.text,
    @required this.themeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final int activedIndex = context.watch<SkinProvider>().themeIndex;
    return GestureDetector(
      onTap: () async {
        context.read<SkinProvider>().changeTheme(
              themeIndex: themeIndex,
              theme: Style.themeList[themeIndex],
              color: Style.colorList[themeIndex],
            );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('themeIndex', themeIndex);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 15.h,
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
                    color: Color.fromRGBO(120, 120, 120, 0.1),
                    blurRadius: themeIndex == activedIndex ? 24 : 6,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              height: 65.h,
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
                    color: themeIndex == activedIndex
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
