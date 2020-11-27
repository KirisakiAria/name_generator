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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(''),
              background: Image.network(
                'https://cn.bing.com/th?id=OIP.xq1C2fmnSw5DEoRMC86vJwD6D6&pid=Api&rs=1',
                fit: BoxFit.fill,
              ),
              //标题是否居中
              centerTitle: true,
              //标题间距
              titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 16),
              collapseMode: CollapseMode.none,
            ),
          ),
        ],
        semanticChildCount: 6, //可见子元素的总数
      ),
    );
  }
}
