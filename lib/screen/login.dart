//核心库
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//第三方库
import 'package:provider/provider.dart';
//请求
import '../services/api.dart';
import '../services/request.dart';
//组件
import '../widgets/custom_button.dart';
//common
import '../common/style.dart';
import '../common/optionsData.dart';
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
              padding: EdgeInsets.only(top: 80, bottom: 30),
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/images/kingdom-4.png'),
                width: 150,
              )),
          Text(
            '星河一天',
            style: TextStyle(
                fontSize: 36, letterSpacing: 5, fontFamily: 'genkai-mincho'),
          ),
          CustomForm(),
        ],
      )),
    );
  }
}

class CustomForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, top: 85),
      child: Form(
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
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.contains('@') ? 'Do not use the @ char.' : null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
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
                    labelText: '密码',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'NijimiMincho',
                        fontSize: 18)),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return value.contains('@') ? 'Do not use the @ char.' : null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              width: double.infinity,
              child: CustomButton(
                  text: '登录',
                  bgColor: Color(0xff333333),
                  borderColor: Color(0xff333333)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: CustomButton(
                  text: '注册',
                  textColor: Color(0xff333333),
                  bgColor: Colors.white,
                  borderColor: Color(0xff333333)),
            )
          ],
        ),
      ),
    );
  }
}
