//核心库
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//common
import '../../common/style.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

class VipPage extends StatefulWidget {
  @override
  _VipPageState createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VIP',
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => ListTileTheme(
          iconColor: context.watch<SkinProvider>().color['subtitle'],
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
