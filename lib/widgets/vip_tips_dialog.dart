//核心库
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//model
import '../model/skin.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';

class VipTipsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('提示'),
      scrollable: true,
      content: SizedBox(
        width: 330.w,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 50.h),
              child: Text('此功能为VIP用户专享，请升级VIP再使用~'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomButton(
                  text: '取消',
                  bgColor: Style.defaultColor['background'],
                  textColor: Style.defaultColor['button'],
                  borderColor: Style.defaultColor['button'],
                  paddingVertical: 14.h,
                  paddingHorizontal: 40.w,
                  callback: () => Navigator.pop(context),
                ),
                CustomButton(
                  text: '升級',
                  bgColor: context.watch<SkinProvider>().color['button'],
                  textColor: context.watch<SkinProvider>().color['background'],
                  borderColor: Style.defaultColor['button'],
                  paddingVertical: 14.h,
                  paddingHorizontal: 40.w,
                  callback: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.only(
        right: 12.h,
        bottom: 12.h,
      ),
    );
  }
}
