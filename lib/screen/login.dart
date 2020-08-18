//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//页面
import './user.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
//utils
import '../utils/Utils.dart';
//model
import '../model/user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: 35.h,
              ),
              alignment: Alignment.topRight,
              child: Image(
                image: AssetImage('assets/images/peach__blossom.png'),
                width: 210.w,
              ),
            ),
            Text(
              '歳歳年年',
              style: TextStyle(
                fontSize: 36,
                letterSpacing: 15,
                fontFamily: 'NijimiMincho',
              ),
            ),
            CustomForm(),
          ],
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
  String _tel, _password;
  //定义GlobalKey为了获取到form的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _login();
    }
  }

  //登陆
  Future<void> _login() async {
    try {
      final String path = API.login;
      final Response res = await Request.init(context: context).httpPost(
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
              avatar: data['avatar'],
              date: data['date'],
              token: data['token'],
              loginState: true,
            );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', data['username']);
        prefs.setString('tel', data['tel']);
        prefs.setInt('uid', data['uid']);
        prefs.setString('avatar', data['avatar']);
        prefs.setString('date', data['date']);
        prefs.setString('token', data['token']);
        Navigator.pushNamed(context, '/home');
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
        top: 80.h,
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
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(Style.borderColor),
                    ),
                  ),
                  hintText: '请输入您的手机号',
                  labelText: '手机号',
                  labelStyle: TextStyle(
                    fontFamily: 'NijimiMincho',
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
                      color: Color(Style.borderColor),
                    ),
                  ),
                  hintText: '请输入您的密码(6-20位)',
                  labelText: '密碼',
                  labelStyle: TextStyle(
                    fontFamily: 'NijimiMincho',
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
                bgColor: Color(Style.grey20),
                borderColor: Color(Style.grey20),
                callback: () {
                  _formValidate();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20.h,
              ),
              width: double.infinity,
              child: CustomButton(
                text: '注册',
                textColor: Color(Style.grey20),
                bgColor: Colors.white,
                borderColor: Color(Style.grey20),
                callback: () {
                  InheritedUserPage.of(context).changeScreen(index: 2);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 55.h,
              ),
              child: GestureDetector(
                onTap: () {
                  InheritedUserPage.of(context).changeScreen(index: 3);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 3.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black12, //边框颜色
                      ),
                    ),
                  ),
                  child: Text(
                    '忘记密码 ？',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15.h,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black12, //边框颜色
                      ),
                    ),
                  ),
                  child: Text(
                    '暂不登录，直接使用',
                    style: TextStyle(
                      color: Colors.black54,
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
