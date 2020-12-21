//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../../services/api.dart';
import '../../services/request.dart';
//页面
import './user.dart';
//组件
import '../../widgets/custom_button.dart';
//common
import '../../common/style.dart';
//utils
import '../../utils/Utils.dart';
//model
import '../../model/user.dart';
import '../../model/skin.dart';

class LoginPage extends StatelessWidget {
  final FocusNode blankNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(blankNode),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    bottom: 30.h,
                  ),
                  alignment: Alignment.topRight,
                  child: Image(
                    image: AssetImage('assets/images/login/login.png'),
                    width: 210.w,
                  ),
                ),
                const Text(
                  '红笺几许',
                  style: TextStyle(
                    fontSize: 38,
                    letterSpacing: 15,
                  ),
                ),
                CustomForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final FocusNode blankNode = FocusNode();
  String _tel, _password;
  //定义GlobalKey为了获取到form的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate() {
    FocusScope.of(context).requestFocus(blankNode);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _login();
    }
  }

  //登陆
  Future<void> _login() async {
    try {
      final String path = API.login;
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'tel': _tel,
          'password': _password,
        },
      );
      if (res.data['code'] == '1000') {
        final Map data = res.data['data'];
        context.read<UserProvider>().changeUserData(
              username: data['username'],
              tel: data['tel'],
              uid: data['uid'],
              vip: data['vip'],
              vipStartTime: data['vipStartTime'],
              vipEndTime: data['vipEndTime'],
              avatar: data['avatar'],
              date: data['date'],
              token: data['token'],
              loginState: true,
            );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('tel', data['tel']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 50.w,
        right: 50.w,
        top: 65.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                inputFormatters: [
                  //只允许输入数字
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  //长度限制11
                  LengthLimitingTextInputFormatter(11),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    bottom: 1,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.watch<SkinProvider>().color['border'],
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.watch<SkinProvider>().color['border'],
                    ),
                  ),
                  hintText: '请输入您的手机号',
                  labelText: '手机号',
                  labelStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '请输入手机号';
                  }
                  if (!Utils.isPhone(value)) {
                    return '手机号码格式不正确';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _tel = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30.h,
              ),
              child: TextFormField(
                inputFormatters: [
                  //不允许输入汉字
                  FilteringTextInputFormatter.deny(
                    RegExp('[\u4e00-\u9fa5]'),
                  ),
                  //长度限制20
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.watch<SkinProvider>().color['border'],
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.watch<SkinProvider>().color['border'],
                    ),
                  ),
                  hintText: '请输入您的密码(6-20位)',
                  labelText: '密碼',
                  labelStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
                obscureText: true,
                validator: (String value) {
                  if (value.length < 6) {
                    return '密码至少6位';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _password = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 50.h,
              ),
              width: double.infinity,
              child: CustomButton(
                text: '登録',
                bgColor: context.watch<SkinProvider>().color['button'],
                textColor: context.watch<SkinProvider>().color['background'],
                borderColor: context.watch<SkinProvider>().color['background'],
                callback: () => _formValidate(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20.h,
              ),
              width: double.infinity,
              child: CustomButton(
                text: '注册',
                bgColor: Style.defaultColor['background'],
                textColor: Style.defaultColor['button'],
                borderColor: Style.defaultColor['button'],
                callback: () => InheritedUserPage.of(context).changeScreen(2),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 50.h,
              ),
              child: GestureDetector(
                onTap: () => InheritedUserPage.of(context).changeScreen(3),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            context.watch<SkinProvider>().color['line'], //边框颜色
                      ),
                    ),
                  ),
                  child: Text(
                    '忘记密码 ？',
                    style: TextStyle(
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15.h,
                bottom: 15.h,
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/home',
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 3,
                  ),
                  margin: EdgeInsets.only(
                    bottom: 20.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            context.watch<SkinProvider>().color['line'], //边框颜色
                      ),
                    ),
                  ),
                  child: Text(
                    '暂不登录，直接使用',
                    style: TextStyle(
                      color: context.watch<SkinProvider>().color['subtitle'],
                    ),
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
