//核心库
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
//第三方库
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import './api.dart';
//common
import '../common/global.dart';
//组件
import '../widgets/loading_dialog.dart';
//model
import '../model/user.dart';

class Request {
  //超时时间
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000;

  final Dio _dio = Dio();

  Request.init(BuildContext context) {
    _dio.options.headers = {
      'appname': Global.appName,
      'packagename': Global.packageName,
      'version': Global.version,
      'buildnumber': Global.buildNumber,
      'authorization': context.read<User>().token,
      'secret': API.secret,
    };
    _dio.options.baseUrl = API.api_prefix;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      //请求时显示loader
      showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return LoadingDialog();
        },
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: anim1.value,
            child: child,
          );
        },
      );
      // 在请求被发送之前做一些事情
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response response) async {
      //在返回响应数据之前做一些预处理
      if (response.data['code'] != '1000') {
        final SnackBar snackBar =
            SnackBar(content: Text(response.data['message']));
        Scaffold.of(context).showSnackBar(snackBar);
      }
      Navigator.pop(context);
      return response; // continue
    }));
  }

  //get
  Future<Response> httpGet(String path) {
    return request(path, 'get', null);
  }

  //post
  Future<Response> httpPost(String path, dynamic data) {
    return request(path, 'post', data);
  }

  Future<Response> httpPut(String path, dynamic data) {
    return request(path, 'put', data);
  }

  Future<Response> request(String path, String method, dynamic data) async {
    Response response;
    try {
      switch (method) {
        case 'get':
          response = await _dio.get(path);
          return response;
        case 'post':
          response = await _dio.post<Map<String, dynamic>>(path, data: data);
          return response;
        case 'put':
          response = await _dio.put<Map<String, dynamic>>(path, data: data);
          return response;
      }
    } on DioError catch (exception) {
      print('请求出错：${exception.toString()}');
    } catch (error) {
      print('请求出错：${error.toString()}');
    }
    return response;
  }
}
