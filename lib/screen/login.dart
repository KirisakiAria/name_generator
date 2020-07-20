//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//页面
import './user.dart';
//组件
import '../widgets/custom_button.dart';
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
              padding: EdgeInsets.only(bottom: 30),
              alignment: Alignment.topRight,
              child: Image(
                image: AssetImage('assets/images/peach__blossom.png'),
                width: 240,
              ),
            ),
            Text(
              '歳歳年年',
              style: TextStyle(
                  fontSize: 36, letterSpacing: 15, fontFamily: 'NijimiMincho'),
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
  String tel, password;
  //定义GlobalKey为了获取到form的状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _login(context);
    }
  }

  //登陆
  Future<void> _login(BuildContext context) async {
    try {
      String path = '${API.login}';
      Response res = await Request.init(context).httpPost(path, {
        'tel': tel,
        'password': password,
      });
      if (res.data['code'] == '1000') {
        Map data = res.data['data'];
        context.read<User>().changeOptions(
              username: data['username'],
              tel: data['tel'],
              avatar: data['avatar'],
              token: data['token'],
              loginState: true,
            );
        Navigator.pushNamed(context, '/home');
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, top: 75),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                inputFormatters: [
                  //只允许输入数字
                  WhitelistingTextInputFormatter.digitsOnly,
                  //长度限制11
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffd2d2d2),
                    ),
                  ),
                  hintText: '请输入您的手机号',
                  labelText: '手机号',
                  labelStyle: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'NijimiMincho',
                      fontSize: 18),
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
                  tel = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextFormField(
                inputFormatters: [
                  //不允许输入汉字
                  FilteringTextInputFormatter.deny(
                    RegExp("[\u4e00-\u9fa5]"),
                  ),
                  //长度限制20
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffd2d2d2),
                    ),
                  ),
                  hintText: '请输入您的密码',
                  labelText: '密碼',
                  labelStyle: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'NijimiMincho',
                      fontSize: 18),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
                onSaved: (String value) {
                  password = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              width: double.infinity,
              child: CustomButton(
                  text: '登録',
                  bgColor: Color(0xff333333),
                  borderColor: Color(0xff333333),
                  callback: () => {_formValidate(context)}),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: CustomButton(
                  text: '注册',
                  textColor: Color(0xff333333),
                  bgColor: Colors.white,
                  borderColor: Color(0xff333333),
                  callback: () => {
                        InheritedUserPage.of(context)
                            .changeShowRegister(show: true)
                      }),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(bottom: 3),
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
            )
          ],
        ),
      ),
    );
  }
}
