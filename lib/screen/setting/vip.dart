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
import '../../common/custom_icon_data.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

class VipPage extends StatefulWidget {
  @override
  _VipPageState createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  final List<Map<String, dynamic>> _vipBenefitsList = <Map<String, dynamic>>[
    <String, dynamic>{
      'icon': CustomIconData.vipDictionary,
      'title': '高级词库',
      'desc': '解锁六字以上的VIP专属词库，可查询到更多网名',
    },
    <String, dynamic>{
      'icon': CustomIconData.vipSearch,
      'title': '高级搜索',
      'desc': '可以在搜索时设置高级搜索选项，例如情侣模式等',
    },
    <String, dynamic>{
      'icon': CustomIconData.vipCouples,
      'title': '情侣模式',
      'desc': '解锁情侣模式，可以生成或者搜索情侣网名',
    },
    <String, dynamic>{
      'icon': CustomIconData.vipRecord,
      'title': '扩充记录',
      'desc': '收藏记录和搜索记录扩大至500条',
    },
    <String, dynamic>{
      'icon': CustomIconData.vip,
      'title': '更多功能',
      'desc': '未来将会更新更多VIP专属功能，敬请期待',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //修改颜色
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          'VIP会员',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xff191919),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 20.h,
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(30.w),
                    width: 320.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage('assets/images/vip/vip_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 65.w,
                          height: 65.w,
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(65),
                                side: BorderSide(
                                  color: Color(0xffeccb94),
                                  width: 5,
                                ),
                              ),
                            ),
                            child: ClipOval(
                              //透明图像占位符
                              child: FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,
                                image:
                                    '${API.origin}${context.watch<UserProvider>().avatar}',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 14.h,
                          ),
                          child: Text(
                            context.watch<UserProvider>().username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.h,
                          ),
                          child: Text(
                            '会员状态：未开通',
                            style: TextStyle(
                              color: Color(0xfffadfbe),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 60.h,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 12.h,
                              ),
                              child: Image(
                                image: AssetImage('assets/images/vip/vip.png'),
                                width: 36.w,
                              ),
                            ),
                            Text(
                              '会员权益',
                              style: TextStyle(
                                color: Color(0xfffadfbe),
                                fontSize: 20,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 25.h,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                      leading: Container(
                        width: 54.h,
                        height: 54.h,
                        margin: EdgeInsets.only(
                          right: 5.w,
                        ),
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: Color(0xfffadfbe),
                        ),
                        child: Center(
                          child: Icon(
                            IconData(
                              _vipBenefitsList[index]['icon'],
                              fontFamily: 'iconfont',
                            ),
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        _vipBenefitsList[index]['title'],
                        style: TextStyle(
                          color: Color(0xfffadfbe),
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        _vipBenefitsList[index]['desc'],
                        style: TextStyle(
                          color: Color(0xfffadfbe),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    itemCount: _vipBenefitsList.length,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
