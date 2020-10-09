//核心库
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
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
//model
import '../model/skin.dart';
//utils
import '../utils/Utils.dart';

class ChangePasswordPage extends StatelessWidget {
  final FocusNode blankNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            !InheritedUserPage.of(context).loginLinkIsShowed,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(blankNode),
        child: SingleChildScrollView(
          child: CustomForm(),
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
  String tel, authCode, password;
  String _btnStr = '获取验证码';
  int _count = 59;
  Timer _timer;
  //定义GlobalKey为了获取到form的状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //表单验证
  void _formValidate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _changePassword();
    }
  }

  //获取验证码
  Future<void> _getAuthCode() async {
    try {
      _formKey.currentState.save();
      if (Utils.isPhone(tel)) {
        final String path = API.getAuthCode;
        final Response res = await Request(
          context: context,
        ).httpPost(
          path,
          <String, dynamic>{
            'tel': tel,
            'change': '1',
          },
        );
        if (res.data['code'] == '1000') {
          _countdown();
          final SnackBar snackBar = SnackBar(
            content: const Text('验证码发送成功'),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);
        }
      } else {
        final SnackBar snackBar = SnackBar(
          content: const Text('请输入正确的手机号'),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print(err);
    }
  }

  //修改密码
  Future<void> _changePassword() async {
    try {
      final String path = API.changePassword;
      final Response res = await Request(
        context: context,
      ).httpPost(
        path,
        <String, dynamic>{
          'tel': tel,
          'authCode': authCode,
          'password': password,
        },
      );
      if (res.data['code'] == '1000') {
        final SnackBar snackBar = SnackBar(
          content: const Text('修改密码成功'),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print(err);
    }
  }

  //验证码倒计时
  void _countdown() {
    setState(() {
      if (_timer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _btnStr = '${_count--}秒重新获取';
      _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          setState(() {
            if (_count > 0) {
              _btnStr = '${_count--}秒重新获取';
            } else {
              _btnStr = '获取验证码';
              _count = 59;
              _timer.cancel();
              _timer = null;
            }
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
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
                autocorrect: false,
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
                      color: Style.defaultColor['border'],
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
                  tel = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30.h,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Style.defaultColor['border'],
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      autocorrect: false,
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
                        focusedBorder:
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
                        authCode = value;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_count > 0) {
                        _getAuthCode();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: 15.w,
                      ),
                      child: Text(
                        _btnStr,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30.h,
              ),
              child: TextFormField(
                autocorrect: false,
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
                      color: Style.defaultColor['border'],
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
                  password = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 50.h,
              ),
              width: double.infinity,
              child: CustomButton(
                text: '修改密碼',
                bgColor: context.watch<SkinProvider>().color['button'],
                textColor: context.watch<SkinProvider>().color['background'],
                borderColor: Style.defaultColor['button'],
                callback: () => _formValidate(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 40.h,
              ),
              child: Offstage(
                offstage: !InheritedUserPage.of(context).loginLinkIsShowed,
                child: GestureDetector(
                  onTap: () => InheritedUserPage.of(context).changeScreen(1),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context
                              .watch<SkinProvider>()
                              .color['line'], //边框颜色
                        ),
                      ),
                    ),
                    child: Text(
                      '登录',
                      style: TextStyle(
                        color: context.watch<SkinProvider>().color['subtitle'],
                      ),
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
