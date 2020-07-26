import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              shadows: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12, //阴影颜色
                  blurRadius: 14, //阴影大小
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    '加载中',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
