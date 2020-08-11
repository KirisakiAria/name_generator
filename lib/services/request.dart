//核心库
import 'dart:async';
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

  Request.init({BuildContext context}) {
    _dio.options.headers = {
      'appname': Global.appName,
      'packagename': Global.packageName,
      'version': Global.version,
      'buildnumber': Global.buildNumber,
      'authorization': context != null ? context.read<User>().token : '',
      'secret': API.secret,
    };
    _dio.options.baseUrl = API.api_prefix;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if (context != null) {
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
          }
          return options; //continue
        },
        onResponse: (Response response) async {
          if (context != null) {
            if (response.data['code'] != '1000') {
              final SnackBar snackBar =
                  SnackBar(content: Text(response.data['message']));
              Scaffold.of(context).showSnackBar(snackBar);
            }
            Navigator.pop(context);
          }
          return response;
        },
        onError: (DioError e) {
          if (context != null) {
            Navigator.pop(context);
          }
        },
      ),
    );
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

  Future<Response> httpDelete(String path) {
    return request(path, 'delete', null);
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
        case 'delete':
          response = await _dio.delete(path);
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
