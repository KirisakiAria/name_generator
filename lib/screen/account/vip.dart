//核心库
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
import '../../common/style.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

const Color defaultColor = Color(0xfffadfbe);

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

  List<dynamic> _planList = <dynamic>[];

  int _planId = 1;

  bool _vip = false;
  String _vipEndTime = '';

  Future<void> _getUserData() async {
    final String path = API.getUserData;
    final Response res = await Request(
      context: context,
    ).httpPost(
      path,
      <String, String>{
        'tel': context.read<UserProvider>().tel,
      },
    );
    if (res.data['code'] == '1000') {
      final Map data = res.data['data'];
      print(data);
      context.read<UserProvider>().changeUserData(
            username: data['username'],
            tel: data['tel'],
            uid: data['uid'],
            vip: data['vip'],
            vipStartTime: data['vipStartTime'],
            vipEndTime: data['vipEndTime'],
            avatar: data['avatar'],
            date: data['date'],
            loginState: true,
          );
      setState(() {
        _vip = data['vip'];
        _vipEndTime = data['vipEndTime'];
      });
    }
  }

  Future<void> _getPlanData() async {
    final String path = API.plan;
    final Response res = await Request(
      context: context,
    ).httpGet('$path');
    if (res.data['code'] == '1000') {
      setState(() {
        _planList = res.data['data']['list'];
      });
    }
  }

  Future<void> _purchase() async {
    final String path = API.purchase;
    final Response res = await Request(
      context: context,
    ).httpPost(
      path,
      <String, dynamic>{
        'tel': context.read<UserProvider>().tel,
        'planId': _planId,
      },
    );
    if (res.data['code'] == '1000') {
      _getUserData();
    }
  }

  @override
  void initState() {
    super.initState();
    _getPlanData();
    _getUserData();
  }

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
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            color: Style.grey20,
            backgroundColor: Colors.white,
            onRefresh: _getUserData,
            child: SingleChildScrollView(
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
                          padding: EdgeInsets.all(
                            30.h,
                          ),
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
                                    shape: CircleBorder(
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
                                  top: 8.h,
                                ),
                                child: Text(
                                  '会员状态：${_vip ? 'VIP会员' : '未开通'}',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 8.h,
                                ),
                                child: Text(
                                  '到期时间：${_vip ? _vipEndTime : '未开通'}',
                                  style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ItemTitle('会员套餐'),
                        Container(
                          padding: EdgeInsets.only(
                            top: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          height: 160.h,
                          child: ListView.separated(
                            padding: EdgeInsets.only(
                              top: 10.h,
                            ),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _planId = _planList[index]['planId'];
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 105.w,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                                decoration: ShapeDecoration(
                                  color: _planId == _planList[index]['planId']
                                      ? Color.fromRGBO(255, 238, 196, .15)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: defaultColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      _planList[index]['title'],
                                      style: TextStyle(
                                        color: defaultColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _planList[index]['currentPrice'],
                                      style: TextStyle(
                                        color: Color(0xfffff0b6),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _planList[index]['originalPrice'],
                                      style: TextStyle(
                                        color: Color(0xffc1c1c1),
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    VerticalDivider(
                              width: 16.0,
                            ),
                            itemCount: _planList.length,
                          ),
                        ),
                        ItemTitle('会员政策'),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                '首先，由衷的感谢所有使用《彼岸自在》的用户。《彼岸自在》作为一款主打网名生成的工具类APP，始终遵守着 《Android绿色应用公约》，无广告、无后台，而我们将秉持这一原则，继续带给广大用户良好的用户体验。独立开发和维护一款APP除了需要极大的时间和经历成本外，还需要非常高昂价格的服务器开销。为了保证一个App能够长久持续地运营下去，我们决定开启VIP会员的功能，如果您能支持我们，对我们来说都是莫大的帮助！真的是非常感谢！',
                                style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '购买VIP会员之前请先阅读  ',
                                      ),
                                      TextSpan(
                                        text: '《会员政策》',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                              context,
                                              '/webview',
                                              arguments: <String, String>{
                                                'title': '服务条款',
                                                'url': '${API.host}/#/vip'
                                              },
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ItemTitle('会员权益'),
                        ListView.builder(
                          padding: EdgeInsets.only(
                            top: 25.h,
                            bottom: 100.h,
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
                                color: Color(0xfffff9e7),
                              ),
                              child: Center(
                                child: Icon(
                                  IconData(
                                    _vipBenefitsList[index]['icon'],
                                    fontFamily: 'iconfont',
                                  ),
                                  size: 24,
                                  color: Color(0xffe6ad12),
                                ),
                              ),
                            ),
                            title: Text(
                              _vipBenefitsList[index]['title'],
                              style: TextStyle(
                                color: defaultColor,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(
                                top: 6.h,
                              ),
                              child: Text(
                                _vipBenefitsList[index]['desc'],
                                style: TextStyle(
                                  color: Color(0xfffff7e0),
                                  fontSize: 14,
                                ),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                bottom: 20.h,
              ),
              child: FlatButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 110.w,
                  vertical: 15.h,
                ),
                color: Color(0xffc78f4f),
                onPressed: () => _purchase(),
                child: Text(
                  '立即购买',
                  style: TextStyle(
                    height: 1.2,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTitle extends StatelessWidget {
  final String title;
  ItemTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 40.h,
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
                title,
                style: TextStyle(
                  color: defaultColor,
                  fontSize: 20,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
