//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:dio/dio.dart';
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

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: CustomForm(),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  String _tel, _authCode, _password;
  //定义GlobalKey为了获取到form的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _register();
    }
  }

  //获取验证码
  Future<void> _getAuthCode() async {
    try {
      _formKey.currentState.save();
      if (Utils.isPhone(_tel)) {
        final String path = API.getAuthCode;
        final Response res = await Request.init(context: context).httpPost(
          path,
          <String, dynamic>{
            'tel': _tel,
          },
        );
        if (res.data['code'] == '1000') {
          final SnackBar snackBar = SnackBar(
            content: const Text('验证码发送成功'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      } else {
        final SnackBar snackBar = SnackBar(
          content: const Text('请输入正确的手机号'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print(err);
    }
  }

  //注册
  Future<void> _register() async {
    try {
      final String path = API.register;
      final Response res = await Request.init(context: context).httpPost(
        path,
        <String, dynamic>{
          'tel': _tel,
          'authCode': _authCode,
          'password': _password,
        },
      );
      if (res.data['code'] == '1000') {
        final SnackBar snackBar = SnackBar(
          content: const Text('注册成功，请登录'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        //2s后自动跳登录页
        Future<void>.delayed(Duration(seconds: 2), () {
          InheritedUserPage.of(context).changeScreen(index: 1);
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 150,
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
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(Style.borderColor),
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        //只允许输入数字
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        //长度限制6
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 1),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        errorBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        hintText: '请输入您的验证码',
                        labelText: '驗證碼',
                        labelStyle: TextStyle(
                          fontFamily: 'NijimiMincho',
                          fontSize: 18,
                        ),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '请输入验证码';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _authCode = value;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _getAuthCode();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '发送验证码',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
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
                  hintText: '请输入您的密码（6-20位）',
                  labelText: '密碼',
                  labelStyle: TextStyle(
                    fontFamily: 'NijimiMincho',
                    fontSize: 18,
                  ),
                ),
                obscureText: true,
                validator: (String value) {
                  if (value.length < 6) {
                    return '密码至少六位';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _password = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              width: double.infinity,
              child: CustomButton(
                text: '注册',
                bgColor: Color(Style.grey20),
                borderColor: Color(Style.grey20),
                callback: () {
                  _formValidate();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: () {
                  InheritedUserPage.of(context).changeScreen(index: 1);
                },
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
                    '已有账号，登录',
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
