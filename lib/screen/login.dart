//核心库
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
import '../widgets/loading_dialog.dart';
//utils
import '../utils/Utils.dart';
//model
import '../model/name_options.dart';

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
              )),
          Text(
            '歳歳年年',
            style: TextStyle(
                fontSize: 36, letterSpacing: 15, fontFamily: 'NijimiMincho'),
          ),
          CustomForm(),
        ],
      )),
    );
  }
}

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  String tel, password;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _formValidate() {
    if (_formKey.currentState.validate()) {
      _login();
    }
  }

  Future _login() async {
    String path = '${Api.login}';
    Response res = await Request.getInstance().httpPost(path, {
      'tel': tel,
      'password': password,
    });
    print(res);
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
                  LengthLimitingTextInputFormatter(11),
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 1),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xffd2d2d2),
                    )),
                    hintText: '请输入您的手机号',
                    labelText: '手机号',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'NijimiMincho',
                        fontSize: 18)),
                onSaved: (String value) {
                  tel = value;
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return '请输入手机号';
                  }
                  if (!Utils.isPhone(value)) {
                    return '手机号码格式不正确';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[\u4e00-\u9fa5]")),
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 1),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xffd2d2d2),
                    )),
                    hintText: '请输入您的密码',
                    labelText: '密碼',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'NijimiMincho',
                        fontSize: 18)),
                onSaved: (String value) {
                  password = value;
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
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
                  callback: () => {_formValidate()}),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: CustomButton(
                  text: '注册',
                  textColor: Color(0xff333333),
                  bgColor: Colors.white,
                  borderColor: Color(0xff333333)),
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
                  )),
                  child: Text('忘记密码 ？',
                      style: TextStyle(
                        color: Colors.black54,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
